  * swift3.+ current release 0.0.6  
    LSXPropertyTool.一款在Swift3.+下一句代码自动生成模型属性的并能一句代码将所有层级的字典，字典数组转换成对应的模型数据的工具。 
  * 使用pod search LSXTPropertyTool  
    pod 'LSXTPropertyTool', '~>0.0.2' 
    pod install  
    notice: 使用pod 安装目前已经提交上去了，不知道要多久，有需要用的直接下载最新release版本导入工程编译：   
    
    使用非常简单：  
      * 1. 生成属性xxx.swift 文件  
          PropertyCodeMake.propertyCodeMake(withDictionaryArray: 网络获取的json字典数组, fileName: “最顶层模型文件名”, filePath: “不含文件名的最近一级目录”)  
      * 2. 将生成的模型文件拖入工程中  
         可以在工程指定的目录下生成，但是必须添加到工程，否则不能识别  
      * 3. JSON数据转模型  
         guard let modelArray = ExchangeToModel.model(withClassName: “首个模型文件名”, withArray: 网络获取的json字典数组) else{  
                return
        }
     * 4. 转换后的数据就可以直接使用了，访问下级模型的属性可以直接点语法(如下：访问数据)
         print(val.created_at ?? "")
         print(val.user?.city ?? "")
         print(val.extend_info?.weibo_camera?.c?[0] ?? "0")
         
