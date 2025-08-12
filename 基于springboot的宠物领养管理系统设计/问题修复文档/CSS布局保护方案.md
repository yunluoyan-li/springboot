# CSS布局保护方案

## 问题描述
用户反映点击左侧目录时，侧边栏和导航栏会消失，需要确保它们始终可见。

## 解决方案

### 1. 创建独立的CSS文件 (`/css/layout.css`)

这个CSS文件使用 `!important` 声明来确保样式优先级最高：

```css
/* 确保导航栏始终可见 */
.navbar {
    position: fixed !important;
    top: 0 !important;
    left: 0 !important;
    right: 0 !important;
    z-index: 1030 !important;
    width: 100% !important;
    background-color: #343a40 !important;
}

/* 确保侧边栏始终可见 */
.sidebar {
    position: fixed !important;
    top: 56px !important;
    left: 0 !important;
    bottom: 0 !important;
    width: 220px !important;
    z-index: 1000 !important;
    background-color: #f8f9fa !important;
    border-right: 1px solid #dee2e6 !important;
    overflow-y: auto !important;
    overflow-x: hidden !important;
    padding: 20px 0 !important;
}
```

### 2. 创建JavaScript保护脚本 (`/js/layout-protection.js`)

这个脚本提供多层保护：

- **强制显示函数**：定期检查并强制显示侧边栏和导航栏
- **DOM监听**：监听DOM变化，防止其他脚本隐藏元素
- **方法重写**：重写可能隐藏元素的jQuery方法
- **定期检查**：每秒检查一次，确保元素始终可见

### 3. 在HTML中引入文件

```html
<!-- 引入CSS文件 -->
<link rel="stylesheet" href="/css/layout.css">

<!-- 引入JavaScript保护脚本 -->
<script src="/js/layout-protection.js"></script>
```

## 保护机制

### CSS层面保护
1. **使用 `!important`**：确保样式优先级最高
2. **固定定位**：使用 `position: fixed` 确保元素始终在指定位置
3. **强制显示**：使用 `display: block !important` 强制显示
4. **防止隐藏**：覆盖可能隐藏元素的CSS类

### JavaScript层面保护
1. **DOM监听**：监听DOM变化，及时恢复被隐藏的元素
2. **方法重写**：重写jQuery的hide()方法，防止隐藏关键元素
3. **定期检查**：每秒检查一次，确保元素始终可见
4. **事件监听**：监听页面加载和AJAX完成事件

## 文件结构

```
src/main/resources/
├── static/
│   ├── css/
│   │   └── layout.css          # 布局保护CSS
│   └── js/
│       └── layout-protection.js # 布局保护JavaScript
└── templates/
    └── main.html               # 主页面模板
```

## 测试验证

1. **点击任何侧边栏链接**：侧边栏和导航栏应该始终保持可见
2. **AJAX加载内容**：即使内容通过AJAX加载，布局也不应该改变
3. **JavaScript错误**：即使有其他JavaScript错误，布局也应该保持稳定
4. **浏览器兼容性**：在不同浏览器中都应该正常工作

## 优势

1. **独立文件**：CSS和JavaScript都是独立文件，便于维护
2. **多层保护**：CSS + JavaScript双重保护，确保万无一失
3. **高性能**：使用高效的DOM监听和定期检查
4. **兼容性好**：支持各种浏览器和jQuery版本
5. **易于调试**：可以单独测试CSS和JavaScript文件

## 注意事项

1. **CSS优先级**：使用 `!important` 确保样式不被覆盖
2. **JavaScript执行顺序**：保护脚本应该在页面加载早期执行
3. **性能考虑**：定期检查间隔设置为1秒，平衡性能和效果
4. **调试模式**：可以在浏览器控制台调用 `window.layoutProtection.forceShowElements()` 手动强制显示 