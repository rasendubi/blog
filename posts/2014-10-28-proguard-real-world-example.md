---
title: ProGuard: Real World Example
author: Alexey Shmalko
tags: Java, obfuscation, ProGuard
keywords: proguard,example,java,obfuscation
description: A non-trivial real-world example of ProGuard usage.
---

[ProGuard](http://proguard.sourceforge.net/index.html) is a free tool for shrinking, optimizing and obfuscating jar files. I've used it at work to protect a commercial application from decompilation, especially critical algorithms (unlike machine code, Java bytecode is easy to decompile).

Here I'll try to describe how I did that.

<!--more-->

### Step 1. Gathering your jars

The final application consists from many modules. The first step is to gather ones developed by our company into single big jar that will be processed by ProGuard.

While obfuscating each module separately, you should keep module's public API untouched so that another module can find necessary classes by name. Processing all modules in one go removes that restriction.

This step is done with maven-shade-plugin. Add the following to your pom.xml:

```xml
<build>
    <plugins>
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-shade-plugin</artifactId>
            <version>2.3</version>
            <executions>
                <execution>
                    <phase>package</phase>
                    <goals><goal>shade</goal></goals>
                </execution>
            </executions>
            <configuration>
                <artifactSet>
                    <includes>
                        <include>com.yourcompany.*:*</include>
                    </includes>

                    <!--
                        maven-shade-plugin experiences issues shading dlls.
                        Unfortunately, our application has several.
                        You could also place some modules you don't want obfuscate.
                    -->
                    <excludes>
                        <exclude>com.yourcompany:native-library</exclude>
                        <exclude>com.yourcompany:another-native-library</exclude>
                    </excludes>
                </artifactSet>

                <transformers>
                    <transformer implementation="org.apache.maven.plugins.shade.resource.ManifestResourceTransformer">

                        <!-- This is entry point of your jar -->
                        <mainClass>com.yourcompany.Main</mainClass>
                    </transformer>
                </transformers>
            </configuration>
        </plugin>
    </plugins>
</build>
```

Note: If you're going to provide your jar packed with all dependencies, remember to exclude all these modules.

### Step 2. Obfuscating

After we generated our monster jar, it's time to do actual job. Luckily, there is maven plugin for ProGuard.

Add the following to your pom.xml __after__ maven-shade-plugin:

```xml
<plugin>
    <groupId>com.github.wvengen</groupId>
    <artifactId>proguard-maven-plugin</artifactId>
    <executions>
        <execution>
            <phase>package</phase>
            <goals><goal>proguard</goal></goals>
        </execution>
    </executions>
    <configuration>
        <!-- Our application is so big that ProGuard had ran out of memory -->
        <maxMemory>1024m</maxMemory>

        <!-- File with proguard configuration -->
        <proguardInclude>${basedir}/proguard.conf</proguardInclude>

        <!-- Now exclude all modules that are embedded in the jar, so that
            ProGuard won't see redefinition of each single class.
            You don't have to write down your main module. -->
        <exclusions>
            <exclusion>
                <groupId>com.yourcompany</groupId>
                <artifactId>data</artifactId>
            </exclusion>

            <!-- And so on -->
        </exclusions>

        <!--
            List external jars your application depends on
            (that not listed in maven dependencies).
            You probably depend on jave runtime (rt.jar).

            JCE stands for Java Cryptography Extension.
            You probably don't need it, but my application does.
        -->
        <libs>
            <lib>${java.home}/lib/rt.jar</lib>
            <lib>${java.home}/lib/jce.jar</lib>
            <lib>${java.home}/lib/ext/sunjce_provider.jar</lib>
        </libs>
    </configuration>
</plugin>
```

The order of plugins is critical. I found that maven runs them from top to bottom if they're bound to the same phase.

Then add the following proguard.conf:

```proguard
# Don't obfuscate or remove your entry point
-keep public class com.yourcompany.Main {
    public static void main(java.lang.String[]);
}

# Supress warnings from javax.servlet
-dontwarn javax.servlet.**

# Uncomment if you want to have more meaningful backtraces
# Useful for obfuscation debugging
# You absolutely must keep this commented out for production
# -keepattributes SourceFile,LineNumberTable
```

This configuration should at least make ProGuard do its job and obfuscate your application. If you're lucky enough and your application works fine &mdash; congratulations, you're done! Go to step 4 now. Otherwise, welcome to the next section.

### Step 3. Fixing application

Most probably, your application now crashes with very strange errors. Don't worry, I'll try to fix that now.

From this point on you should read [ProGuard manual](http://proguard.sourceforge.net/manual/usage.html) for description of options.

#### Reflection

The number one trouble for obfuscation is reflection. To load class dynamically by name you should know its name after obfuscation, otherwise jre couldn't find class for given name. The same applies for dynamically calling methods.

The first option &mdash; don't obfuscate dynamically loaded classes' names. What can be easily? Name after processing equals to name before processing. End of story.

Unfortunately, this is not an option for my application. The most critical part is loaded dynamically and forms complex structure in form described in almost one thousand xml files.

So, what's the solution? Obfuscate all occurrences of class names!

ProGuard has an option for that, but it requires all names to be fully qualified. Fortunately, adapting all xml files opened a way to delete some classes that was copied just to bring them in scope and removed over 21,000 lines.

After that I added the following to proguard.conf:

```proguard
-adaptclassstrings
-adaptresourcefilecontents **.xml


# Also keep - Swing UI L&F. Keep all extensions of javax.swing.plaf.ComponentUI,
# along with the special 'createUI' method.
-keep class * extends javax.swing.plaf.ComponentUI {
    public static javax.swing.plaf.ComponentUI createUI(javax.swing.JComponent);
}
```

##### Wrong solution

I'm not the first programmer who obfuscated our application. The previous one made a horrible terrifying mistake and I don't want you to make the same one.

In order to resolve obfuscated names at runtime, he brought whole obfuscation map (in form of two files that should be xor'ed) in final jar, made special class for resolving original names to obfuscated ones.

In that way he made this single class the most important link of the anti-decompilation chain.

Don't do that!

#### Resource names

Because class' full name probably changed, loading resources relative to class' path will fail.

To fix that, just relocate resource to appropriate place.

```proguard
-adaptresourcefilenames
```

#### Native methods

The issue with native methods is essentially the same as with reflection. Java relies on C function to contain class name, while accessing class fields from C also assumes knowing their names.

While this is theoretically possible to make the necessary transformation of C source code after obfuscation and recompile library, it's not practical. So, the best solution is just to keep all stuff in classes with native methods unobfuscated.

```proguard
-keepclasseswithmembernames,includedescriptorclasses class * {
    native <methods>;
}

# The CPointer field is referenced from dll, keep it
# -keepclasseswithmembers,includedescriptorclasses class com.yourcompany.NativeClass {
#     protected long CPointer;
# }

```

### Step 4. Enabling more obfuscation

At this point you should have your application up and running. It's best time to enable some more obfuscations!

```proguard
# This option removes all package names.
# with -adaptresourcefilenames it may cause some resource files to clash.
# If that happens, try -flattenpackagehierarchy instead
-repackageclasses

-overloadaggressively
-allowaccessmodification
```

### P.S. Optimizing optimization

Everything was working fine for a while, but after a couple of weeks processing started to take enormous amount of time (Jenkins build aborted after 17 hrs building).

After investigation I managed to shrink processing time down to 1 minute by disabling single optimization! Please welcome!

```proguard
-optimizations !code/allocation/variable
```

### Conclusion

I'll be glad to hear your successful obfuscation story with all the barriers you overcome.

As a bonus for reading so far, here is a [list of assumenosideeffects](/files/nosideeffects.txt) I found on StackOverflow. Unfortunately, I can't find it again to tell you original author's name.
