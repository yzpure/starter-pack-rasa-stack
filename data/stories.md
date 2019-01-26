## story_greet <!--- The name of the story. It is not mandatory, but useful for debugging. --> 
* greet <!--- User input expressed as intent. In this case it represents users message 'Hello'. --> 
 - utter_name <!--- The response of the chatbot expressed as an action. In this case it represents chatbot's response 'Hello, how can I help?' --> 
 
## story_goodbye
* goodbye
 - utter_goodbye

## story_thanks
* thanks
 - utter_thanks
 
## story_name
* name{"name":"Sam"}
 - utter_greet
 

## story_joke_01
* joke
 - action_joke
 
## story_joke_02
* greet
 - utter_name
* name{"name":"Lucy"} <!--- User response with an entity. In this case it represents user message 'My name is Lucy.' --> 
 - utter_greet
* joke
 - action_joke
* thanks
 - utter_thanks
* goodbye
 - utter_goodbye 
 
## 新用户注册
* 新用户注册
 - utter_新用户注册
 
## 短信价格
* 短信价格
 - utter_短信价格

## 短信字数
* 短信字数
 - utter_短信字数

## 开通高级用户
* 开通高级用户
 - utter_开通高级用户

## 黑名单介绍
* 黑名单介绍
 - utter_黑名单介绍

## 短信轰炸规则
* 短信轰炸规则
 - utter_短信轰炸规则

## 新手教程
* 新手教程
 - utter_新手教程

## 发送号码是什么
* 发送号码是什么
 - utter_发送号码是什么

## 短信发送方式
* 短信发送方式
 - utter_短信发送方式

## 高级用户和普通用户的区别
* 高级用户和普通用户的区别
 - utter_高级用户和普通用户的区别

## 邀评
* 邀评
 - utter_邀评

## 打招呼
* 打招呼
 - utter_打招呼

## 等待返回是什么意思
* 等待返回是什么意思
 - utter_等待返回是什么意思

## 为什么要加验证码
* 为什么要加验证码
 - utter_为什么要加验证码

## 开通群发短信
* 开通群发短信
 - utter_开通群发短信

## 创建营销账号
* 创建营销账号
 - utter_创建营销账号

## 普通变营销
* 普通变营销
 - utter_普通变营销

## 密保修改
* 密保修改
 - utter_密保修改
