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
                group = 'org.svunit'

                configurations.create('default')

                artifacts {
                    'default'(projectDir)
                }
            }
        }
    }
}
