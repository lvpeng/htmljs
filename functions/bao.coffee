Bao = __M 'baos'
Bao.sync()
User = __M 'users'
User.sync()
Comments = __M 'bao_comments'
Comments.sync()
module.exports =  
  getAll:(page,count,condition,callback)->
    query = 
      offset: (page - 1) * count
      limit: count
      order: "id desc"
    if condition then query.where = condition
    Bao.findAll(query)
    .success (baos)->
      callback null,baos
    .error (error)->
      callback error
  add:(data,callback)->
    Bao.create(data)
    .success (bao)->
      callback null,bao
    .error (error)->
      callback error
  addZan:(id,callback)->
    Bao.find
      where:
        id:id
    .success (bao)->
      if bao
        bao.updateAttributes
          zan_count: if bao.zan_count then (bao.zan_count+1) else 1
        .success ()->
          callback null,bao
        .error (e)->
          callback e
      else
        callback new Error '不存在的爆料'
    .error (e)->
      callback e
  addComment:(baoId,content,visitor,callback)->
    Bao.find
      where:
        id:baoId
    .success (bao)->
      if bao
        bao.updateAttributes
          comment_count: if bao.comment_count then (bao.comment_count+1) else 1
        if visitor
          Comments.create
            bao_id:baoId
            user_id:visitor.id
            user_nick:visitor.nick
            user_headpic:visitor.head_pic
            content:content
          .success (c)->
            callback null,c
          .error (e)->
            callback e
        
      else
        callback new Error '不存在的爆料'