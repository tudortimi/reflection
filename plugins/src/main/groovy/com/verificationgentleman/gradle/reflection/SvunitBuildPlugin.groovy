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

                task('dummyCopy', type: Copy) {
                    from buildFile
                    into buildDir
                }
                configurations.create('default')
                artifacts {
                    'default'(buildDir) {
                        builtBy(dummyCopy)
                    }
                }
            }
        }
    }
}
