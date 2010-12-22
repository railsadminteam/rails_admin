/*
Copyright (c) 2003-2010, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

/**
 * @fileOverview Defines the {@link CKEDITOR.lang} object, for the
 * Vietnamese language.
 */

/**#@+
   @type String
   @example
*/

/**
 * Constains the dictionary of language entries.
 * @namespace
 */
CKEDITOR.lang['vi'] =
{
	/**
	 * The language reading direction. Possible values are "rtl" for
	 * Right-To-Left languages (like Arabic) and "ltr" for Left-To-Right
	 * languages (like English).
	 * @default 'ltr'
	 */
	dir : 'ltr',

	/*
	 * Screenreader titles. Please note that screenreaders are not always capable
	 * of reading non-English words. So be careful while translating it.
	 */
	editorTitle : 'Bộ soạn thảo, %1, nhấn ALT + 0 để xem hướng dẫn.',

	// ARIA descriptions.
	toolbar	: 'Thanh công cụ',
	editor	: 'Bộ soạn thảo',

	// Toolbar buttons without dialogs.
	source			: 'Mã HTML',
	newPage			: 'Trang mới',
	save			: 'Lưu',
	preview			: 'Xem trước',
	cut				: 'Cắt',
	copy			: 'Sao chép',
	paste			: 'Dán',
	print			: 'In',
	underline		: 'Gạch chân',
	bold			: 'Đậm',
	italic			: 'Nghiêng',
	selectAll		: 'Chọn tất cả',
	removeFormat	: 'Xoá định dạng',
	strike			: 'Gạch xuyên ngang',
	subscript		: 'Chỉ số dưới',
	superscript		: 'Chỉ số trên',
	horizontalrule	: 'Chèn đường phân cách ngang',
	pagebreak		: 'Chèn ngắt trang',
	pagebreakAlt		: 'Page Break', // MISSING
	unlink			: 'Xoá liên kết',
	undo			: 'Khôi phục thao tác',
	redo			: 'Làm lại thao tác',

	// Common messages and labels.
	common :
	{
		browseServer	: 'Duyệt trên máy chủ',
		url				: 'URL',
		protocol		: 'Giao thức',
		upload			: 'Tải lên',
		uploadSubmit	: 'Tải lên máy chủ',
		image			: 'Hình ảnh',
		flash			: 'Flash',
		form			: 'Biểu mẫu',
		checkbox		: 'Nút kiểm',
		radio			: 'Nút chọn',
		textField		: 'Trường văn bản',
		textarea		: 'Vùng văn bản',
		hiddenField		: 'Trường ẩn',
		button			: 'Nút',
		select			: 'Ô chọn',
		imageButton		: 'Nút hình ảnh',
		notSet			: '<không thiết lập>',
		id				: 'Định danh',
		name			: 'Tên',
		langDir			: 'Hướng ngôn ngữ',
		langDirLtr		: 'Trái sang phải (LTR)',
		langDirRtl		: 'Phải sang trái (RTL)',
		langCode		: 'Mã ngôn ngữ',
		longDescr		: 'Mô tả URL',
		cssClass		: 'Lớp Stylesheet',
		advisoryTitle	: 'Nhan đề hướng dẫn',
		cssStyle		: 'Kiểu (style)',
		ok				: 'Đồng ý',
		cancel			: 'Bỏ qua',
		close			: 'Đóng',
		preview			: 'Xem trước',
		generalTab		: 'Tab chung',
		advancedTab		: 'Tab mở rộng',
		validateNumberFailed : 'Giá trị này không phải là số.',
		confirmNewPage	: 'Mọi thay đổi không được lưu lại, nội dung này sẽ bị mất. Bạn có chắc chắn muốn tải một trang mới?',
		confirmCancel	: 'Một vài tùy chọn đã bị thay đổi. Bạn có chắc chắn muốn đóng hộp thoại?',
		options			: 'Tùy chọn',
		target			: 'Đích đến',
		targetNew		: 'Cửa sổ mới (_blank)',
		targetTop		: 'Cửa sổ trên cùng (_top)',
		targetSelf		: 'Tại trang (_self)',
		targetParent	: 'Cửa sổ cha (_parent)',
		langDirLTR		: 'Left to Right (LTR)', // MISSING
		langDirRTL		: 'Right to Left (RTL)', // MISSING
		styles			: 'Style', // MISSING
		cssClasses		: 'Stylesheet Classes', // MISSING
		width			: 'Chiều rộng',
		height			: 'chiều cao',
		align			: 'Vị trí',
		alignLeft		: 'Trái',
		alignRight		: 'Phải',
		alignCenter		: 'Giữa',
		alignTop		: 'Trên',
		alignMiddle		: 'Giữa',
		alignBottom		: 'Dưới',
		invalidHeight	: 'Chiều cao phải là số nguyên.',
		invalidWidth	: 'Chiều rộng phải là số nguyên.',

		// Put the voice-only part of the label in the span.
		unavailable		: '%1<span class="cke_accessibility">, không có</span>'
	},

	contextmenu :
	{
		options : 'Tùy chọn menu bổ xung'
	},

	// Special char dialog.
	specialChar		:
	{
		toolbar		: 'Chèn ký tự đặc biệt',
		title		: 'Hãy chọn ký tự đặc biệt',
		options : 'Tùy chọn các ký tự đặc biệt'
	},

	// Link dialog.
	link :
	{
		toolbar		: 'Chèn/Sửa liên kết',
		other 		: '<khác>',
		menu		: 'Sửa liên kết',
		title		: 'Liên kết',
		info		: 'Thông tin liên kết',
		target		: 'Đích',
		upload		: 'Tải lên',
		advanced	: 'Mở rộng',
		type		: 'Kiểu liên kết',
		toUrl		: 'URL',
		toAnchor	: 'Neo trong trang này',
		toEmail		: 'Thư điện tử',
		targetFrame		: '<khung>',
		targetPopup		: '<cửa sổ popup>',
		targetFrameName	: 'Tên khung đích',
		targetPopupName	: 'Tên cửa sổ Popup',
		popupFeatures	: 'Đặc điểm của cửa sổ Popup',
		popupResizable	: 'Có thể thay đổi kích cỡ',
		popupStatusBar	: 'Thanh trạng thái',
		popupLocationBar: 'Thanh vị trí',
		popupToolbar	: 'Thanh công cụ',
		popupMenuBar	: 'Thanh Menu',
		popupFullScreen	: 'Toàn màn hình (IE)',
		popupScrollBars	: 'Thanh cuộn',
		popupDependent	: 'Phụ thuộc (Netscape)',
		popupLeft		: 'Vị trí bên trái',
		popupTop		: 'Vị trí phía trên',
		id				: 'Định danh',
		langDir			: 'Hướng ngôn ngữ',
		langDirLTR		: 'Trái sang phải (LTR)',
		langDirRTL		: 'Phải sang trái (RTL)',
		acccessKey		: 'Phím hỗ trợ truy cập',
		name			: 'Tên',
		langCode		: 'Mã ngôn ngữ',
		tabIndex		: 'Chỉ số của Tab',
		advisoryTitle	: 'Nhan đề hướng dẫn',
		advisoryContentType	: 'Nội dung hướng dẫn',
		cssClasses		: 'Lớp Stylesheet',
		charset			: 'Bảng mã của tài nguyên được liên kết đến',
		styles			: 'Kiểu (style)',
		selectAnchor	: 'Chọn một điểm neo',
		anchorName		: 'Theo tên điểm neo',
		anchorId		: 'Theo định danh thành phần',
		emailAddress	: 'Thư điện tử',
		emailSubject	: 'Tiêu đề thông điệp',
		emailBody		: 'Nội dung thông điệp',
		noAnchors		: '(Không có điểm neo nào trong tài liệu)',
		noUrl			: 'Hãy đưa vào đường dẫn liên kết (URL)',
		noEmail			: 'Hãy đưa vào địa chỉ thư điện tử'
	},

	// Anchor dialog
	anchor :
	{
		toolbar		: 'Chèn/Sửa điểm neo',
		menu		: 'Thuộc tính điểm neo',
		title		: 'Thuộc tính điểm neo',
		name		: 'Tên của điểm neo',
		errorName	: 'Hãy nhập vào tên của điểm neo'
	},

	// List style dialog
	list:
	{
		numberedTitle		: 'Thuộc tính danh sách có thứ tự',
		bulletedTitle		: 'Thuộc tính danh sách không thứ tự',
		type				: 'Kiểu loại',
		start				: 'Bắt đầu',
		validateStartNumber				:'List start number must be a whole number.', // MISSING
		circle				: 'Khuyên tròn',
		disc				: 'Hình đĩa',
		square				: 'Hình vuông',
		none				: 'Không gì cả',
		notset				: '<không thiết lập>',
		armenian			: 'Số theo kiểu Armenian',
		georgian			: 'Số theo kiểu Georgian (an, ban, gan...)',
		lowerRoman			: 'Số La Mã kiểu thường (i, ii, iii, iv, v...)',
		upperRoman			: 'Số La Mã kiểu HOA (I, II, III, IV, V...)',
		lowerAlpha			: 'Kiểu abc thường (a, b, c, d, e...)',
		upperAlpha			: 'Kiểu ABC HOA (A, B, C, D, E...)',
		lowerGreek			: 'Kiểu Hy Lạp (alpha, beta, gamma...)',
		decimal				: 'Kiểu số (1, 2, 3 ...)',
		decimalLeadingZero	: 'Kiểu số (01, 02, 03...)'
	},

	// Find And Replace Dialog
	findAndReplace :
	{
		title				: 'Tìm kiếm và thay thế',
		find				: 'Tìm kiếm',
		replace				: 'Thay thế',
		findWhat			: 'Tìm chuỗi:',
		replaceWith			: 'Thay bằng:',
		notFoundMsg			: 'Không tìm thấy chuỗi cần tìm.',
		matchCase			: 'Phân biệt chữ hoa/thường',
		matchWord			: 'Giống toàn bộ từ',
		matchCyclic			: 'Giống một phần',
		replaceAll			: 'Thay thế tất cả',
		replaceSuccessMsg	: '%1 vị trí đã được thay thế.'
	},

	// Table Dialog
	table :
	{
		toolbar		: 'Bảng',
		title		: 'Thuộc tính bảng',
		menu		: 'Thuộc tính bảng',
		deleteTable	: 'Xóa bảng',
		rows		: 'Số hàng',
		columns		: 'Số cột',
		border		: 'Kích thước đường viền',
		widthPx		: 'Điểm ảnh (px)',
		widthPc		: 'Phần trăm (%)',
		widthUnit	: 'Đơn vị',
		cellSpace	: 'Khoảng cách giữa các ô',
		cellPad		: 'Khoảng đệm giữ ô và nội dung',
		caption		: 'Đầu đề',
		summary		: 'Tóm lược',
		headers		: 'Đầu đề',
		headersNone		: 'Không có',
		headersColumn	: 'Cột đầu tiên',
		headersRow		: 'Hàng đầu tiên',
		headersBoth		: 'Cả hai',
		invalidRows		: 'Số lượng hàng phải là một số lớn hơn 0.',
		invalidCols		: 'Số lượng cột phải là một số lớn hơn 0.',
		invalidBorder	: 'Kích cỡ của đường biên phải là một số nguyên.',
		invalidWidth	: 'Chiều rộng của bảng phải là một số nguyên.',
		invalidHeight	: 'Chiều cao của bảng phải là một số nguyên.',
		invalidCellSpacing	: 'Khoảng cách giữa các ô phải là một số nguyên.',
		invalidCellPadding	: 'Khoảng đệm giữa ô và nội dung phải là một số nguyên.',

		cell :
		{
			menu			: 'Ô',
			insertBefore	: 'Chèn ô Phía trước',
			insertAfter		: 'Chèn ô Phía sau',
			deleteCell		: 'Xoá ô',
			merge			: 'Kết hợp ô',
			mergeRight		: 'Kết hợp sang phải',
			mergeDown		: 'Kết hợp xuống dưới',
			splitHorizontal	: 'Phân tách ô theo chiều ngang',
			splitVertical	: 'Phân tách ô theo chiều dọc',
			title			: 'Thuộc tính của ô',
			cellType		: 'Kiểu của ô',
			rowSpan			: 'Kết hợp hàng',
			colSpan			: 'Kết hợp cột',
			wordWrap		: 'Chữ liền hàng',
			hAlign			: 'Canh lề ngang',
			vAlign			: 'Canh lề dọc',
			alignBaseline	: 'Đường cơ sở',
			bgColor			: 'Màu nền',
			borderColor		: 'Màu viền',
			data			: 'Dữ liệu',
			header			: 'Đầu đề',
			yes				: 'Có',
			no				: 'Không',
			invalidWidth	: 'Chiều rộng của ô phải là một số nguyên.',
			invalidHeight	: 'Chiều cao của ô phải là một số nguyên.',
			invalidRowSpan	: 'Số hàng kết hợp phải là một số nguyên.',
			invalidColSpan	: 'Số cột kết hợp phải là một số nguyên.',
			chooseColor		: 'Chọn màu'
		},

		row :
		{
			menu			: 'Hàng',
			insertBefore	: 'Chèn hàng phía trước',
			insertAfter		: 'Chèn hàng phía sau',
			deleteRow		: 'Xoá hàng'
		},

		column :
		{
			menu			: 'Cột',
			insertBefore	: 'Chèn cột phía trước',
			insertAfter		: 'Chèn cột phía sau',
			deleteColumn	: 'Xoá cột'
		}
	},

	// Button Dialog.
	button :
	{
		title		: 'Thuộc tính của nút',
		text		: 'Chuỗi hiển thị (giá trị)',
		type		: 'Kiểu',
		typeBtn		: 'Nút bấm',
		typeSbm		: 'Nút gửi',
		typeRst		: 'Nút nhập lại'
	},

	// Checkbox and Radio Button Dialogs.
	checkboxAndRadio :
	{
		checkboxTitle : 'Thuộc tính nút kiểm',
		radioTitle	: 'Thuộc tính nút chọn',
		value		: 'Giá trị',
		selected	: 'Được chọn'
	},

	// Form Dialog.
	form :
	{
		title		: 'Thuộc tính biểu mẫu',
		menu		: 'Thuộc tính biểu mẫu',
		action		: 'Hành động',
		method		: 'Phương thức',
		encoding	: 'Bảng mã'
	},

	// Select Field Dialog.
	select :
	{
		title		: 'Thuộc tính ô chọn',
		selectInfo	: 'Thông tin',
		opAvail		: 'Các tùy chọn có thể sử dụng',
		value		: 'Giá trị',
		size		: 'Kích cỡ',
		lines		: 'dòng',
		chkMulti	: 'Cho phép chọn nhiều',
		opText		: 'Văn bản',
		opValue		: 'Giá trị',
		btnAdd		: 'Thêm',
		btnModify	: 'Thay đổi',
		btnUp		: 'Lên',
		btnDown		: 'Xuống',
		btnSetValue : 'Giá trị được chọn',
		btnDelete	: 'Nút xoá'
	},

	// Textarea Dialog.
	textarea :
	{
		title		: 'Thuộc tính vùng văn bản',
		cols		: 'Số cột',
		rows		: 'Số hàng'
	},

	// Text Field Dialog.
	textfield :
	{
		title		: 'Thuộc tính trường văn bản',
		name		: 'Tên',
		value		: 'Giá trị',
		charWidth	: 'Độ rộng của ký tự',
		maxChars	: 'Số ký tự tối đa',
		type		: 'Kiểu',
		typeText	: 'Ký tự',
		typePass	: 'Mật khẩu'
	},

	// Hidden Field Dialog.
	hidden :
	{
		title	: 'Thuộc tính trường ẩn',
		name	: 'Tên',
		value	: 'Giá trị'
	},

	// Image Dialog.
	image :
	{
		title		: 'Thuộc tính của ảnh',
		titleButton	: 'Thuộc tính nút của ảnh',
		menu		: 'Thuộc tính của ảnh',
		infoTab		: 'Thông tin của ảnh',
		btnUpload	: 'Tải lên máy chủ',
		upload		: 'Tải lên',
		alt			: 'Chú thích ảnh',
		lockRatio	: 'Giữ nguyên tỷ lệ',
		unlockRatio	: 'Phá bỏ tỷ lệ',
		resetSize	: 'Kích thước gốc',
		border		: 'Đường viền',
		hSpace		: 'Khoảng đệm ngang',
		vSpace		: 'Khoảng đệm dọc',
		alertUrl	: 'Hãy đưa vào đường dẫn của ảnh',
		linkTab		: 'Tab liên kết',
		button2Img	: 'Bạn có muốn chuyển nút bấm bằng ảnh được chọn thành ảnh?',
		img2Button	: 'Bạn có muốn chuyển đổi ảnh được chọn thành nút bấm bằng ảnh?',
		urlMissing	: 'Thiếu đường dẫn hình ảnh',
		validateBorder	: 'Chiều rộng của đường viền phải là một số nguyên dương',
		validateHSpace	: 'Khoảng đệm ngang phải là một số nguyên dương',
		validateVSpace	: 'Khoảng đệm dọc phải là một số nguyên dương'
	},

	// Flash Dialog
	flash :
	{
		properties		: 'Thuộc tính Flash',
		propertiesTab	: 'Thuộc tính',
		title			: 'Thuộc tính Flash',
		chkPlay			: 'Tự động chạy',
		chkLoop			: 'Lặp',
		chkMenu			: 'Cho phép bật menu của Flash',
		chkFull			: 'Cho phép toàn màn hình',
 		scale			: 'Tỷ lệ',
		scaleAll		: 'Hiển thị tất cả',
		scaleNoBorder	: 'Không đường viền',
		scaleFit		: 'Vừa vặn',
		access			: 'Truy cập mã',
		accessAlways	: 'Luôn luôn',
		accessSameDomain: 'Cùng tên miền',
		accessNever		: 'Không bao giờ',
		alignAbsBottom	: 'Dưới tuyệt đối',
		alignAbsMiddle	: 'Giữa tuyệt đối',
		alignBaseline	: 'Đường cơ sở',
		alignTextTop	: 'Phía trên chữ',
		quality			: 'Chất lượng',
		qualityBest		: 'Tốt nhất',
		qualityHigh		: 'Cao',
		qualityAutoHigh	: 'Cao tự động',
		qualityMedium	: 'Trung bình',
		qualityAutoLow	: 'Thấp tự động',
		qualityLow		: 'Thấp',
		windowModeWindow: 'Cửa sổ',
		windowModeOpaque: 'Mờ đục',
		windowModeTransparent : 'Trong suốt',
		windowMode		: 'Chế độ cửa sổ',
		flashvars		: 'Các biến số dành cho Flash',
		bgcolor			: 'Màu nền',
		hSpace			: 'Khoảng đệm ngang',
		vSpace			: 'Khoảng đệm dọc',
		validateSrc		: 'Hãy đưa vào đường dẫn liên kết',
		validateHSpace	: 'Khoảng đệm ngang phải là số nguyên.',
		validateVSpace	: 'Khoảng đệm dọc phải là số nguyên.'
	},

	// Speller Pages Dialog
	spellCheck :
	{
		toolbar			: 'Kiểm tra chính tả',
		title			: 'Kiểm tra chính tả',
		notAvailable	: 'Xin lỗi, dịch vụ này hiện tại không có.',
		errorLoading	: 'Lỗi khi đang nạp dịch vụ ứng dụng: %s.',
		notInDic		: 'Không có trong từ điển',
		changeTo		: 'Chuyển thành',
		btnIgnore		: 'Bỏ qua',
		btnIgnoreAll	: 'Bỏ qua tất cả',
		btnReplace		: 'Thay thế',
		btnReplaceAll	: 'Thay thế tất cả',
		btnUndo			: 'Phục hồi lại',
		noSuggestions	: '- Không đưa ra gợi ý về từ -',
		progress		: 'Đang tiến hành kiểm tra chính tả...',
		noMispell		: 'Hoàn tất kiểm tra chính tả: Không có lỗi chính tả',
		noChanges		: 'Hoàn tất kiểm tra chính tả: Không có từ nào được thay đổi',
		oneChange		: 'Hoàn tất kiểm tra chính tả: Một từ đã được thay đổi',
		manyChanges		: 'Hoàn tất kiểm tra chính tả: %1 từ đã được thay đổi',
		ieSpellDownload	: 'Chức năng kiểm tra chính tả chưa được cài đặt. Bạn có muốn tải về ngay bây giờ?'
	},

	smiley :
	{
		toolbar	: 'Hình biểu lộ cảm xúc (mặt cười)',
		title	: 'Chèn hình biểu lộ cảm xúc (mặt cười)',
		options : 'Tùy chọn hình  biểu lộ cảm xúc'
	},

	elementsPath :
	{
		eleLabel : 'Nhãn thành phần',
		eleTitle : '%1 thành phần'
	},

	numberedlist	: 'Danh sách có thứ tự',
	bulletedlist	: 'Danh sách không thứ tự',
	indent			: 'Dịch vào trong',
	outdent			: 'Dịch ra ngoài',

	justify :
	{
		left	: 'Canh trái',
		center	: 'Canh giữa',
		right	: 'Canh phải',
		block	: 'Canh đều'
	},

	blockquote : 'Khối trích dẫn',

	clipboard :
	{
		title		: 'Dán',
		cutError	: 'Các thiết lập bảo mật của trình duyệt không cho phép trình biên tập tự động thực thi lệnh cắt. Hãy sử dụng bàn phím cho lệnh này (Ctrl/Cmd+X).',
		copyError	: 'Các thiết lập bảo mật của trình duyệt không cho phép trình biên tập tự động thực thi lệnh sao chép. Hãy sử dụng bàn phím cho lệnh này (Ctrl/Cmd+C).',
		pasteMsg	: 'Hãy dán nội dung vào trong khung bên dưới, sử dụng tổ hợp phím (<STRONG>Ctrl/Cmd+V</STRONG>) và nhấn vào nút <STRONG>Đồng ý</STRONG>.',
		securityMsg	: 'Do thiết lập bảo mật của trình duyệt nên trình biên tập không thể truy cập trực tiếp vào nội dung đã sao chép. Bạn cần phải dán lại nội dung vào cửa sổ này.',
		pasteArea	: 'Khu vực dán'
	},

	pastefromword :
	{
		confirmCleanup	: 'Văn bản bạn muốn dán có kèm định dạng của Word. Bạn có muốn loại bỏ định dạng Word trước khi dán?',
		toolbar			: 'Dán với định dạng Word',
		title			: 'Dán với định dạng Word',
		error			: 'It was not possible to clean up the pasted data due to an internal error' // MISSING
	},

	pasteText :
	{
		button	: 'Dán theo định dạng văn bản thuần',
		title	: 'Dán theo định dạng văn bản thuần'
	},

	templates :
	{
		button			: 'Mẫu dựng sẵn',
		title			: 'Nội dung Mẫu dựng sẵn',
		options : 'Tùy chọn mẫu dựng sẵn',
		insertOption	: 'Thay thế nội dung hiện tại',
		selectPromptMsg	: 'Hãy chọn mẫu dựng sẵn để mở trong trình biên tập<br>(nội dung hiện tại sẽ bị mất):',
		emptyListMsg	: '(Không có mẫu dựng sẵn nào được định nghĩa)'
	},

	showBlocks : 'Hiển thị các khối',

	stylesCombo :
	{
		label		: 'Kiểu',
		panelTitle	: 'Phong cách định dạng',
		panelTitle1	: 'Kiểu khối',
		panelTitle2	: 'Kiểu trực tiếp',
		panelTitle3	: 'Kiểu đối tượng'
	},

	format :
	{
		label		: 'Định dạng',
		panelTitle	: 'Định dạng',

		tag_p		: 'Bình thường (P)',
		tag_pre		: 'Đã thiết lập',
		tag_address	: 'Address',
		tag_h1		: 'Heading 1',
		tag_h2		: 'Heading 2',
		tag_h3		: 'Heading 3',
		tag_h4		: 'Heading 4',
		tag_h5		: 'Heading 5',
		tag_h6		: 'Heading 6',
		tag_div		: 'Bình thường (DIV)'
	},

	div :
	{
		title				: 'Tạo khối các thành phần',
		toolbar				: 'Tạo khối các thành phần',
		cssClassInputLabel	: 'Các lớp CSS',
		styleSelectLabel	: 'Kiểu (style)',
		IdInputLabel		: 'Định danh (id)',
		languageCodeInputLabel	: 'Mã ngôn ngữ',
		inlineStyleInputLabel	: 'Kiểu nội dòng',
		advisoryTitleInputLabel	: 'Nhan đề hướng dẫn',
		langDirLabel		: 'Hướng ngôn ngữ',
		langDirLTRLabel		: 'Trái sang phải (LTR)',
		langDirRTLLabel		: 'Phải qua trái (RTL)',
		edit				: 'Chỉnh sửa',
		remove				: 'Xóa bỏ'
  	},

	iframe :
	{
		title		: 'iFrame Properties', // MISSING
		toolbar		: 'iFrame', // MISSING
		noUrl		: 'Please type the iFrame URL', // MISSING
		scrolling	: 'Enable scrollbars', // MISSING
		border		: 'Show frame border' // MISSING
	},

	font :
	{
		label		: 'Phông',
		voiceLabel	: 'Phông',
		panelTitle	: 'Phông'
	},

	fontSize :
	{
		label		: 'Cỡ chữ',
		voiceLabel	: 'Kích cỡ phông',
		panelTitle	: 'Cỡ chữ'
	},

	colorButton :
	{
		textColorTitle	: 'Màu chữ',
		bgColorTitle	: 'Màu nền',
		panelTitle		: 'Màu sắc',
		auto			: 'Tự động',
		more			: 'Màu khác...'
	},

	colors :
	{
		'000' : 'Black', // MISSING
		'800000' : 'Maroon', // MISSING
		'8B4513' : 'Saddle Brown', // MISSING
		'2F4F4F' : 'Dark Slate Gray', // MISSING
		'008080' : 'Teal', // MISSING
		'000080' : 'Navy', // MISSING
		'4B0082' : 'Indigo', // MISSING
		'696969' : 'Dark Gray', // MISSING
		'B22222' : 'Fire Brick', // MISSING
		'A52A2A' : 'Brown', // MISSING
		'DAA520' : 'Golden Rod', // MISSING
		'006400' : 'Dark Green', // MISSING
		'40E0D0' : 'Turquoise', // MISSING
		'0000CD' : 'Medium Blue', // MISSING
		'800080' : 'Purple', // MISSING
		'808080' : 'Gray', // MISSING
		'F00' : 'Red', // MISSING
		'FF8C00' : 'Dark Orange', // MISSING
		'FFD700' : 'Gold', // MISSING
		'008000' : 'Green', // MISSING
		'0FF' : 'Cyan', // MISSING
		'00F' : 'Blue', // MISSING
		'EE82EE' : 'Violet', // MISSING
		'A9A9A9' : 'Dim Gray', // MISSING
		'FFA07A' : 'Light Salmon', // MISSING
		'FFA500' : 'Orange', // MISSING
		'FFFF00' : 'Yellow', // MISSING
		'00FF00' : 'Lime', // MISSING
		'AFEEEE' : 'Pale Turquoise', // MISSING
		'ADD8E6' : 'Light Blue', // MISSING
		'DDA0DD' : 'Plum', // MISSING
		'D3D3D3' : 'Light Grey', // MISSING
		'FFF0F5' : 'Lavender Blush', // MISSING
		'FAEBD7' : 'Antique White', // MISSING
		'FFFFE0' : 'Light Yellow', // MISSING
		'F0FFF0' : 'Honeydew', // MISSING
		'F0FFFF' : 'Azure', // MISSING
		'F0F8FF' : 'Alice Blue', // MISSING
		'E6E6FA' : 'Lavender', // MISSING
		'FFF' : 'White' // MISSING
	},

	scayt :
	{
		title			: 'Kiểm tra chính tả ngay khi gõ chữ (SCAYT)',
		opera_title		: 'Không hỗ trợ trên trình duyệt Opera',
		enable			: 'Bật SCAYT',
		disable			: 'Tắt SCAYT',
		about			: 'Thông tin về SCAYT',
		toggle			: 'Bật tắt SCAYT',
		options			: 'Tùy chọn',
		langs			: 'Ngôn ngữ',
		moreSuggestions	: 'Đề xuất thêm',
		ignore			: 'Bỏ qua',
		ignoreAll		: 'Bỏ qua tất cả',
		addWord			: 'Thêm từ',
		emptyDic		: 'Tên của từ điển không được để trống.',

		optionsTab		: 'Tùy chọn',
		allCaps			: 'Không phân biệt chữ HOA chữ thường',
		ignoreDomainNames : 'Bỏ qua tên miền',
		mixedCase		: 'Không phân biệt loại chữ',
		mixedWithDigits	: 'Không phân biệt chữ và số',

		languagesTab	: 'Tab ngôn ngữ',

		dictionariesTab	: 'Từ điển',
		dic_field_name	: 'Tên từ điển',
		dic_create		: 'Tạo',
		dic_restore		: 'Phục hồi',
		dic_delete		: 'Xóa',
		dic_rename		: 'Thay tên',
		dic_info		: 'Initially the User Dictionary is stored in a Cookie. However, Cookies are limited in size. When the User Dictionary grows to a point where it cannot be stored in a Cookie, then the dictionary may be stored on our server. To store your personal dictionary on our server you should specify a name for your dictionary. If you already have a stored dictionary, please type its name and click the Restore button.', // MISSING

		aboutTab		: 'Thông tin'
	},

	about :
	{
		title		: 'Thông tin về CKEditor',
		dlgTitle	: 'Thông tin về CKEditor',
		moreInfo	: 'Vui lòng ghé thăm trang web của chúng tôi để có thông tin về giấy phép:',
		copy		: 'Bản quyền &copy; $1. Giữ toàn quyền.'
	},

	maximize : 'Phóng to tối đa',
	minimize : 'Thu nhỏ',

	fakeobjects :
	{
		anchor		: 'Điểm neo',
		flash		: 'Flash',
		iframe		: 'iFrame', // MISSING
		hiddenfield	: 'Hidden Field', // MISSING
		unknown		: 'Đối tượng không rõ ràng'
	},

	resize : 'Kéo rê để thay đổi kích cỡ',

	colordialog :
	{
		title		: 'Chọn màu',
		options	:	'Color Options', // MISSING
		highlight	: 'Màu chọn',
		selected	: 'Màu đã chọn',
		clear		: 'Xóa bỏ'
	},

	toolbarCollapse	: 'Thu gọn thanh công cụ',
	toolbarExpand	: 'Mở rộng thnah công cụ',

	bidi :
	{
		ltr : 'Text direction from left to right', // MISSING
		rtl : 'Text direction from right to left' // MISSING
	}
};
