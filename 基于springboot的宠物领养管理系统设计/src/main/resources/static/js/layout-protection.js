// 强制保护侧边栏和导航栏始终可见的JavaScript
(function() {
    'use strict';
    
    // 强制显示侧边栏和导航栏的函数
    function forceShowElements() {
        // 强制显示侧边栏
        const sidebar = document.querySelector('.sidebar');
        if (sidebar) {
            // 使用setAttribute来设置样式，确保优先级最高
            sidebar.setAttribute('style', `
                position: fixed !important;
                top: 56px !important;
                left: 0 !important;
                bottom: 0 !important;
                width: 220px !important;
                z-index: 9998 !important;
                background-color: #f8f9fa !important;
                border-right: 1px solid #dee2e6 !important;
                overflow-y: auto !important;
                overflow-x: hidden !important;
                padding: 20px 0 !important;
                display: block !important;
                visibility: visible !important;
                opacity: 1 !important;
                min-width: 220px !important;
                max-width: 220px !important;
            `);
            
            // 移除任何可能隐藏的类
            sidebar.classList.remove('d-none', 'invisible', 'hidden', 'collapsed', 'd-none');
            sidebar.classList.add('sidebar-visible');
        }
        
        // 强制显示导航栏
        const navbar = document.querySelector('.navbar');
        if (navbar) {
            navbar.setAttribute('style', `
                position: fixed !important;
                top: 0 !important;
                left: 0 !important;
                right: 0 !important;
                z-index: 9999 !important;
                width: 100% !important;
                background-color: #343a40 !important;
                display: block !important;
                visibility: visible !important;
                opacity: 1 !important;
                height: 56px !important;
                min-height: 56px !important;
                max-height: 56px !important;
            `);
            
            // 移除任何可能隐藏的类
            navbar.classList.remove('d-none', 'invisible', 'hidden', 'collapsed');
            navbar.classList.add('navbar-visible');
        }
        
        // 确保主内容区域正确定位
        const mainContent = document.querySelector('.main-content');
        if (mainContent) {
            mainContent.setAttribute('style', `
                margin-left: 220px !important;
                margin-top: 56px !important;
                padding: 20px !important;
                min-height: calc(100vh - 56px) !important;
                width: calc(100% - 220px) !important;
                position: relative !important;
                z-index: 1 !important;
            `);
        }
    }
    
    // 监听DOM变化，防止其他脚本隐藏元素
    function observeDOMChanges() {
        const observer = new MutationObserver(function(mutations) {
            let needsUpdate = false;
            
            mutations.forEach(function(mutation) {
                if (mutation.type === 'attributes') {
                    const target = mutation.target;
                    if (target.classList && 
                        (target.classList.contains('sidebar') || target.classList.contains('navbar'))) {
                        needsUpdate = true;
                    }
                    
                    // 检查style属性变化
                    if (mutation.attributeName === 'style') {
                        const style = target.getAttribute('style') || '';
                        if (style.includes('display: none') || 
                            style.includes('visibility: hidden') || 
                            style.includes('opacity: 0')) {
                            needsUpdate = true;
                        }
                    }
                    
                    // 检查class属性变化
                    if (mutation.attributeName === 'class') {
                        const className = target.className || '';
                        if (className.includes('d-none') || 
                            className.includes('invisible') || 
                            className.includes('hidden')) {
                            needsUpdate = true;
                        }
                    }
                }
            });
            
            if (needsUpdate) {
                setTimeout(forceShowElements, 0);
            }
        });
        
        // 观察整个文档的变化
        observer.observe(document.body, {
            attributes: true,
            childList: true,
            subtree: true,
            attributeFilter: ['style', 'class']
        });
    }
    
    // 重写可能隐藏元素的函数
    function protectStyles() {
        // 重写hide方法
        const originalHide = Element.prototype.hide;
        Element.prototype.hide = function() {
            if (this.classList && 
                (this.classList.contains('sidebar') || this.classList.contains('navbar'))) {
                console.log('阻止隐藏侧边栏或导航栏');
                return this; // 不允许隐藏
            }
            if (originalHide) {
                return originalHide.call(this);
            }
            return this;
        };
        
        // 重写jQuery的hide方法
        if (window.jQuery) {
            const originalJQueryHide = window.jQuery.fn.hide;
            window.jQuery.fn.hide = function() {
                this.each(function() {
                    if (this.classList && 
                        (this.classList.contains('sidebar') || this.classList.contains('navbar'))) {
                        console.log('jQuery阻止隐藏侧边栏或导航栏');
                        return false; // 不允许隐藏
                    }
                });
                if (originalJQueryHide) {
                    return originalJQueryHide.call(this);
                }
                return this;
            };
        }
        
        // 重写style设置
        const originalSetAttribute = Element.prototype.setAttribute;
        Element.prototype.setAttribute = function(name, value) {
            if (name === 'style' && 
                this.classList && 
                (this.classList.contains('sidebar') || this.classList.contains('navbar'))) {
                // 检查是否试图隐藏元素
                if (value.includes('display: none') || 
                    value.includes('visibility: hidden') || 
                    value.includes('opacity: 0')) {
                    console.log('阻止通过setAttribute隐藏侧边栏或导航栏');
                    return; // 不允许设置隐藏样式
                }
            }
            return originalSetAttribute.call(this, name, value);
        };
    }
    
    // 定期检查并强制显示
    function periodicCheck() {
        setInterval(function() {
            const sidebar = document.querySelector('.sidebar');
            const navbar = document.querySelector('.navbar');
            
            if (sidebar && (sidebar.style.display === 'none' || 
                           sidebar.style.visibility === 'hidden' || 
                           sidebar.classList.contains('d-none'))) {
                console.log('检测到侧边栏被隐藏，强制显示');
                forceShowElements();
            }
            
            if (navbar && (navbar.style.display === 'none' || 
                          navbar.style.visibility === 'hidden' || 
                          navbar.classList.contains('d-none'))) {
                console.log('检测到导航栏被隐藏，强制显示');
                forceShowElements();
            }
        }, 500); // 每500毫秒检查一次
    }
    
    // 页面加载完成后执行
    function init() {
        console.log('初始化布局保护...');
        
        // 立即执行一次
        forceShowElements();
        
        // 延迟执行，确保DOM完全加载
        setTimeout(function() {
            forceShowElements();
            observeDOMChanges();
            protectStyles();
            periodicCheck();
        }, 100);
        
        // 监听页面加载事件
        window.addEventListener('load', function() {
            console.log('页面加载完成，强制显示元素');
            forceShowElements();
        });
        
        // 监听DOM内容加载事件
        document.addEventListener('DOMContentLoaded', function() {
            console.log('DOM内容加载完成，强制显示元素');
            forceShowElements();
        });
        
        // 监听AJAX完成事件
        document.addEventListener('readystatechange', function() {
            if (document.readyState === 'complete') {
                console.log('页面状态完成，强制显示元素');
                forceShowElements();
            }
        });
    }
    
    // 如果DOM已经加载，立即执行；否则等待DOM加载
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }
    
    // 导出函数供其他脚本使用
    window.layoutProtection = {
        forceShowElements: forceShowElements,
        init: init
    };
    
    // 确保在页面卸载前也保持保护
    window.addEventListener('beforeunload', function() {
        forceShowElements();
    });
    
})(); 