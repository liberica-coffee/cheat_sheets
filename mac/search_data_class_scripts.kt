import java.io.File

//fun main(args: Array<String>) {
//    if (args.isEmpty()) {
//        println("Specify the file path as arguments, please")
//        return
//    }
//
//    val filePath = args[0]
//    val file = File(filePath)
//
//    if (file.exists()) {
//        println("File exists: ${file.absolutePath}")
//    } else {
//        println(""File not found.: $filePath")
//    }
//}


fun main() {





    // old file name
    // /Users/komachi/work/KotlinSpringbootGradle/src/main/kotlin/br/com/testkotlinboot/pocKotlinBoot/service/MainControllerService.kt
    // config the parameters
    //val projectRoot = File("./") // root dir
    val projectRoot = File("/Users/komachi/work/KotlinSpringbootGradle/") //project root dir
    println("projectRoot: ${projectRoot}")

    //val serviceDir = File(projectRoot, "src/main/kotlin/com/example/service")
    val serviceDir = File(projectRoot, "src/main/kotlin/br/com/testkotlinboot/pocKotlinBoot/service")
    println("serviceDir: ${serviceDir}")

    // List
    val oldServicePackageNameList = serviceDir.toString().split("/")
    val oldServicePackageNameListIndex = oldServicePackageNameList.indexOf("kotlin") + 1
    val oldServicePackageNameTargetList = oldServicePackageNameList.subList(oldServicePackageNameListIndex, oldServicePackageNameList.size)
    val oldServicePackageName = oldServicePackageNameTargetList.joinToString(".")

    val targetFile = "MainControllerService.kt"
    //val entityDir = File(projectRoot, "src/main/kotlin/com/example/entity")
    val entityDir = File(projectRoot, "src/main/kotlin/br/com/testkotlinboot/pocKotlinBoot/entity")
    println("entityDir: ${entityDir}")

//    val entityPackage = "com.example.entity"

//    entityDir.toString().replace("/",".").indexOf("kotlin")[52]
    val entityPackageNew = entityDir.toString()
    // entity package string
    val kotlinIndexStringList = entityDir.toString().split("/").toList()
    // index of kotlin
    val kotlinIndexNew = kotlinIndexStringList.indexOf("kotlin") + 1
    // get the string from the index location of kotlin to the end
    val entityPackageNewList = kotlinIndexStringList.subList(kotlinIndexNew, kotlinIndexStringList.size )

    val entityPackageName = entityPackageNewList.joinToString(".")
    println("entityPackageName: $entityPackageName")

    // check the path is existed or not
    if (!entityDir.exists()) {
        // if not existed, create a new  directory
        entityDir.mkdirs()
    }

    // regex data class
    //val dataClassRegex = Regex("""data\s+class\s+\w+\s*\(.*\)\s*""", RegexOption.DOT_MATCHES_ALL)
    val dataClassRegex = Regex("""class\s+\w+\s*\(.*\)\s*""", RegexOption.DOT_MATCHES_ALL)

    serviceDir.walkTopDown().filter { it.isFile && it.extension == "kt" }.forEach { file ->
        val content = file.readText()

        // find all of files which includes the data class parts
        val matches = dataClassRegex.findAll(content).map { it.value }.toList()
        if (matches.isNotEmpty()) {
            val newFileName = file.nameWithoutExtension + "DataList.kt"
            val newFile = File(entityDir, newFileName)

            // build a new file content
            val newContent = buildString {
                appendLine("package $entityPackageName")
                appendLine()
                matches.forEach { appendLine(it) }
            }

            newFile.writeText(newContent)
            println("Generated the file: ${newFile.absolutePath}")

            // replace the package name
//            val updatedContent = content.replace("com.example.service", entityPackage)
//            val updatedContent = content.replace(oldServicePackageName, entityPackageName)
            // should append the name of data class
            val updatedContent = content.replace(oldServicePackageName, entityPackageName)
            file.writeText(updatedContent)
            println("Updated the impoort : ${file.absolutePath}")
        }
    }
}



//---------------------


なるほど 👍。`java.io.File` 自体は「ファイルやディレクトリを表すクラス」であって、**スクリプトの引数を指定する機能は持っていません**。  
「Kotlin スクリプトにファイルパスを引数として渡したい」という意味なら、やり方は次のようになります。

---

## 🔹 Kotlin の `main` 関数で引数を受け取る
```kotlin
import java.io.File

fun main(args: Array<String>) {
    if (args.isEmpty()) {
        println("ファイルパスを引数に指定してください")
        return
    }

    val filePath = args[0]              // 最初の引数をファイルパスとして受け取る
    val file = File(filePath)

    if (file.exists()) {
        println("ファイルが存在します: ${file.absolutePath}")
    } else {
        println("ファイルが存在しません: $filePath")
    }
}
```

---

## 🔹 実行方法
### 1. Kotlin スクリプト (`.kts`) の場合
```bash
kotlinc -script MyScript.kts myfile.txt
```
- `args[0]` に `"myfile.txt"` が入ります。

### 2. Kotlin コンパイル済みプログラムの場合
```bash
kotlinc Main.kt -include-runtime -d main.jar
java -jar main.jar myfile.txt
```
- `args[0]` に `"myfile.txt"` が入ります。

---

## 🔹 ポイント
- `args` は **コマンドライン引数**を受け取る配列。
- `File(args[0])` でそのパスを `java.io.File` として扱える。
- `exists()`, `isFile`, `isDirectory` などで状態を確認できる。

---

✅ まとめると：  
「スクリプトにファイルを指定したい」＝ **コマンドライン引数としてファイルパスを渡し、`File(args[0])` で扱う** という流れになります。  

👉 もし「複数のファイルを引数に渡したい」ケースもありますか？


🔹 複数のファイルを引数に渡す方法

複数のファイルを引数として渡したい場合は、args 配列の複数の要素を使います。例えば、次のようにすれば複数ファイルを処理できます。

import java.io.File

fun main(args: Array<String>) {
    if (args.isEmpty()) {
        println("ファイルパスを引数に指定してください")
        return
    }

    for (filePath in args) {
        val file = File(filePath)
        if (file.exists()) {
            println("ファイルが存在します: ${file.absolutePath}")
        } else {
            println("ファイルが存在しません: $filePath")
        }
    }
}

実行例

java -jar main.jar file1.txt file2.txt file3.txt

この場合、args[0] に file1.txt、args[1] に file2.txt、args[2] に file3.txt が入ります。

---


  
