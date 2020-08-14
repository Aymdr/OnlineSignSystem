//这里是显示PDF等一系列js文件
var curid="";
var curid_src="";
function clickedId(evt) {
    curid = "";
    if (evt) {//非ie
        var curid_temp = evt.target.id;
        curid = curid + curid_temp;
    }
    else if (window.event) {//ie
        var curid_temp = window.event.srcElement.id;
        curid = curid + curid_temp;
    }
    curid_src = document.getElementById(curid).src
}

// 显示PDF部分
var __PDF_DOC,
    __CURRENT_PAGE,
    __TOTAL_PAGES,
    __PAGE_RENDERING_IN_PROGRESS = 0,
    __CANVAS = $('#pdf-canvas').get(0)
    // __CANVAS_CTX = __CANVAS.getContext('2d');
var seal_position= {x: 0,	y: 0};

//显示PDF
function showPDF(pdf_url) {
    //显示加载文档的提示语
    $("#pdf-loader").show();

    PDFJS.getDocument({ url: pdf_url }).then(
        function(pdf_doc) {
            //选择的PDF文档
            __PDF_DOC = pdf_doc;
            __TOTAL_PAGES = __PDF_DOC.numPages;
            //将提示语隐藏并加载pdf内容到HTML上
            $("#pdf-loader").hide();
            $("#pdf-contents").show();
            $("#pdf-total-pages").text(__TOTAL_PAGES);

            // 函数显示第一页
            showPage(1);
        }).catch(function(error) {
        // 若发生错误则重新显示加载PDF按钮
        $("#pdf-loader").hide();
        $("#upload-button").show();
        alert(error.message);
    });;
}
//根据页码显示当前页
function showPage(page_no) {
    __PAGE_RENDERING_IN_PROGRESS = 1;
    __CURRENT_PAGE = page_no;

    // Disable Prev & Next buttons while page is being loaded
    $("#pdf-next, #pdf-prev").attr('disabled', 'disabled');

    //当页面正在被渲染了，隐藏canvas并显示加载信息
    $("#pdf-canvas").hide();
    $("#page-loader").show();
    $("#download-image").hide();

    //更新当前页码
    $("#pdf-current-page").text(page_no);

    // Fetch the page
    __PDF_DOC.getPage(page_no).then(function(page) {
        //自适应调整窗宽
        var scale_required = __CANVAS.width / page.getViewport(1).width;

        // Get viewport of the page at required scale
        var viewport = page.getViewport(scale_required);

        // Set canvas height
        __CANVAS.height = viewport.height;

        var renderContext = {
            canvasContext: __CANVAS_CTX,
            viewport: viewport
        };
        // Render the page contents in the canvas
        page.render(renderContext).then(function() {
            __PAGE_RENDERING_IN_PROGRESS = 0;

            // Re-enable Prev & Next buttons
            $("#pdf-next, #pdf-prev").removeAttr('disabled');

            // Show the canvas and hide the page loader
            $("#pdf-canvas").show();
            $("#page-loader").hide();
            $("#download-image").show();
        });
    });
}

// Upon click this should should trigger click on the #file-to-upload file input element
// This is better than showing the not-good-looking file input element
$("#upload-button").on('click', function() {
    $("#file-to-upload").trigger('click');
});

// When user chooses a PDF file
$("#file-to-upload").on('change', function() {
    // Validate whether PDF
    if(['application/pdf'].indexOf($("#file-to-upload").get(0).files[0].type) == -1) {
        alert('Error : Not a PDF');
        return;
    }

    $("#upload-button").hide();

    // Send the object url of the pdf
    showPDF(URL.createObjectURL($("#file-to-upload").get(0).files[0]));
});

// Previous page of the PDF
$("#pdf-prev").on('click', function() {
    if(__CURRENT_PAGE != 1)
        showPage(--__CURRENT_PAGE);
});

// Next page of the PDF
$("#pdf-next").on('click', function() {
    if(__CURRENT_PAGE != __TOTAL_PAGES)
        showPage(++__CURRENT_PAGE);
});

// Download button
$("#download-image").on('click', function() {
    var img = $('#seal');
    var imgs = document.createElement('img');
    imgs.src= img.src;
    var pdf_canvas = document.getElementById("pdf-canvas");
    //  alert("x : " + $('#pdf-canvas').position().left);
    //   alert("seal_position : " + seal_position.x );
    //  alert("y : " + $('#pdf-canvas').position().top);
    //  alert("y : " + seal_position.y);
    // alert("x y : " + seal_position.x - pdf_canvas.x + "  " + seal_position.y - pdf_canvas.y);
    // __CANVAS_CTX.drawImage(imgs, seal_position.x - $('#pdf-canvas').position().left, seal_position.y - $('#pdf-canvas').position().top);
    __CANVAS_CTX.drawImage(imgs, 0, 0);

    $(this).attr('href', __CANVAS.toDataURL()).attr('download', 'page.png');
});