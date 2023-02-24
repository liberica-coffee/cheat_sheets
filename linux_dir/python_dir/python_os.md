os.mknod("text.txt")：创建空文件

os.system():运行shell命令
os.exit():终止当前进程

os.getcwd() 取得当前工作目录

os.getenv()读取环境变量
os.putenv()设置环境变量
os.environ['MY_USER']

os.chdir('dirname') 改变目录

os.mkdir('dirname') 创建目录
os.makedirs('dirname')多层目录

os.rmdir('dirname') 删除目录
os.removedirs('dirname') 多层目录

os.remove(‘path/filename’) 删除文件

os.rename(oldname, newname) 重命名文件

os.walk() 生成目录树下的所有文件名

os.stat（file）:获得文件属性

os.listdir('dirname') 列出指定目录的文件

os.chmod() 改变目录权限

os.path.abspath(path) #返回绝对路径
os.path.basename(path) #返回文件名
os.path.commonprefix(list) #返回list(多个路径)中，所有path共有的最长的路径。'
os.path.dirname(path) #返回文件路径
os.path.exists(path) #路径存在则返回True,路径损坏返回False
os.path.lexists              #路径存在则返回True,路径损坏也返回True
os.path.expanduser(path)    #把path中包含的"~"和"~user"转换成用户目录
os.path.expandvars(path)    #根据环境变量的值替换path中包含的”$name”和”${name}”
os.path.getatime(path)      #返回最后一次进入此path的时间。
os.path.getmtime(path)      #返回在此path下最后一次修改的时间。
os.path.getctime(path)      #返回path的大小
os.path.getsize(path)       #返回文件大小，如果文件不存在就返回错误
os.path.isabs(path)         #判断是否为绝对路径
os.path.isfile(path)        #判断路径是否为文件
os.path.isdir(path)         #判断路径是否为目录
os.path.islink(path)        #判断路径是否为链接
os.path.ismount(path)       #判断路径是否为挂载点（）
os.path.join(path1[, path2[, ...]])         #把目录和文件名合成一个路径'
os.path.normcase(path)      #转换path的大小写和斜杠
os.path.normpath(path)      #规范path字符串形式
os.path.realpath(path)      #返回path的真实路径
os.path.relpath(path[, start])  #从start开始计算相对路径'
os.path.samefile(path1, path2)  #判断目录或文件是否相同'
os.path.sameopenfile(fp2, fp2)  #判断fp1和fp2是否指向同一文件'
os.path.samestat(stat1, stat2)  #判断stat tuple stat1和stat2是否指向同一个文件'
os.path.split(path)     #把路径分割成dirname和basename，返回一个元组
os.path.splitdrive(path)     #一般用在windows下，返回驱动器名和路径组成的元组
os.path.splitext(path)  #分割路径，返回路径名和文件扩展名的元组
os.path.splitunc(path)      #把路径分割为加载点与文件
os.path.walk(path, visit, arg)  #遍历path，进入每个目录都调用visit函数，visit函数必须有'
    #3个参数(arg, dirname, names)，dirname表示当前目录的目录名，names代表当前目录下的所有
    #文件名，args则为walk的第三个参数
os.path.supports_unicode_filenames      #设置是否支持unicode路径名
os.sep:取代操作系统特定的路径分隔符
os.name:指示你正在使用的工作平台。比如对于Windows，它是'nt'，而对于Linux/Unix用户，它是'posix'。

参考：
+ 版权声明：本文为CSDN博主「ghostwritten」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
+ 原文链接：https://blog.csdn.net/xixihahalelehehe/article/details/104253123
