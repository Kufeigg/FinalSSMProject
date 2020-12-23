<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>layui</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/statics/layui/lib/layui-v2.5.5/css/layui.css" media="all">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/statics/layui/css/public.css" media="all">
</head>
<body>
<div class="layuimini-container">
    <div class="layuimini-main">

        <fieldset class="table-search-fieldset">
            <legend>搜索信息</legend>
            <div style="margin: 10px 10px 10px 10px">
                <form class="layui-form layui-form-pane" action="">
                    <div class="layui-form-item">
                        <div class="layui-inline">
                            <label class="layui-form-label">订单编号</label>
                            <div class="layui-input-inline">
                                <input type="text" name="gName" autocomplete="off" class="layui-input">
                            </div>
                        </div>
                        <div class="layui-inline">
                            <button type="submit" class="layui-btn layui-btn"  lay-submit lay-filter="data-search-btn"><i class="layui-icon layui-icon-search"></i> 搜 索</button>
                            <button type="reset" class="layui-btn layui-btn-warm"><i class="layui-icon layui-icon-refresh-1"></i> 重 置</button>
                        </div>
                    </div>
                </form>
            </div>
        </fieldset>

        <script type="text/html" id="toolbarDemo">
            <div class="layui-btn-container">
                <button class="layui-btn layui-btn-sm layui-btn-danger data-delete-btn" lay-event="delete"> 删除 </button>
            </div>
        </script>

        <table class="layui-hide" id="currentTableId" lay-filter="currentTableFilter"></table>

        <script type="text/html" id="currentTableBar">
            <a class="layui-btn layui-btn-normal layui-btn-xs data-count-edit" lay-event="edit">编辑</a>
            <a class="layui-btn layui-btn-xs layui-btn-danger data-count-delete" lay-event="delete">删除</a>
        </script>

    </div>
</div>
<script src="${pageContext.request.contextPath}/statics/layui/lib/layui-v2.5.5/layui.js" charset="utf-8"></script>
<script>
    layui.use(['form', 'table'], function () {
        var $ = layui.jquery,
            form = layui.form,
            table = layui.table;

        table.render({
            elem: '#currentTableId',
            url: '${pageContext.request.contextPath}/admin/goods/list',
            toolbar: '#toolbarDemo',
            defaultToolbar: ['filter', 'exports', 'print', {
                title: '提示',
                layEvent: 'LAYTABLE_TIPS',
                icon: 'layui-icon-tips'
            }],
            cols: [[
                {type: "checkbox", width: 50},
                {field: 'id', width: 80, title: '商品编号', sort: true},
                {field: 'busertable_id', width: 150, title: '用户邮箱'},
                {field: 'amount', width: 150, title: '订单金额', sort: true},
                {field: 'status', width: 150, title: '订单状态', sort: true},
                {field: 'orderdata', width: 80, title: '订单日期', sort: true},
                {title: '操作', minWidth: 150, toolbar: '#currentTableBar', align: "center"}
            ]],
            limits: [10, 15, 20, 25, 50, 100],
            limit: 15,
            page: true,
            skin: 'line'
        });

        // 监听搜索操作
        form.on('submit(data-search-btn)', function (data) {
            console.log(data.field);
            $.post("/ShoppingSystem_war/admin/order/orderSearch",data.field,function (result) {
            },"json");

            //执行搜索重载
            table.reload('currentTableId', {
                page: {
                    curr: 1
                }
                , where: {
                    searchParams: result
                }
            }, 'data');

            return false;
        });

        /**
         * toolbar监听事件
         */
        table.on('toolbar(currentTableFilter)', function (obj) {
            if (obj.event === 'delete') {  // 监听删除操作
                var checkStatus = table.checkStatus('currentTableId')
                    , data = checkStatus.data;
                console.log(data)
                var ids = [];
                for (var i=0;i<data.length;i++) {
                    ids.push(data[i].id)
                }
                var str = ids.join(',');
                console.log(str);
                layer.confirm('真的删除么?', function (index) {

                    $.ajax({
                        type : "POST", //提交方式
                        url : "${pageContext.request.contextPath}/admin/order/orderDelete",//路径
                        data : {
                            "str" : str
                        },//数据，这里使用的是Json格式进行传输
                        success : function(result) {//返回数据根据结果进行相应的处理
                            console.log(JSON.parse(result));
                            var result = JSON.parse(result)
                            if (result.success) {
                                layer.alert("删除成功！");
                                obj.del();
                            } else {
                                layer.alert("操作异常！");
                            }
                        }
                    });
                    layer.close(index);
                });

            }
        });

        //监听表格复选框选择
        table.on('checkbox(currentTableFilter)', function (obj) {
            console.log(obj)
        });

        table.on('tool(currentTableFilter)', function (obj) {
            var dataId = obj.data.id;

            if (obj.event === 'delete') {

                layer.confirm('真的删除么?', function (index) {

                    $.ajax({
                        type : "POST", //提交方式
                        url : "${pageContext.request.contextPath}/admin/order/orderDelete",//路径
                        data : {
                            "id" : dataId
                        },//数据，这里使用的是Json格式进行传输
                        success : function(result) {//返回数据根据结果进行相应的处理

                            console.log(JSON.parse(result));
                            var result = JSON.parse(result)

                            if (result.success) {
                                layer.alert("删除成功！");
                                obj.del();
                            } else {
                                layer.alert("操作异常！");
                            }
                        }
                    });

                    layer.close(index);
                });
            }
        });

    });
</script>

</body>
</html>