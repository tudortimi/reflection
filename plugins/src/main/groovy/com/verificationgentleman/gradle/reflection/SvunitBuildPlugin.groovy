package com.verificationgentleman.gradle.reflection

import org.gradle.api.initialization.*
import org.gradle.api.file.*
import org.gradle.api.tasks.*
import org.gradle.api.attributes.*
import org.gradle.api.*

class SvunitBuildPlugin implements Plugin<Settings> {
    void apply(Settings settings) {
        settings.with {
            rootProject.name = 'svunit'
            gradle.rootProject {
                group = 'com.verificationgentleman'
                version = '1.0-SNAPSHOT'

                task('dummyCopy', type: Copy) {
                    from buildFile
                    into buildDir
                }
                configurations {
                    'default' {
                        canBeConsumed = true
                        canBeResolved = false
                        attributes {
                            attribute(Attribute.of(String), 'cloneSvunit')
                        }
                    }
                }
                artifacts {
                    'default'(buildDir) {
                        builtBy(dummyCopy)
                    }
                }
            }
        }
    }
}
