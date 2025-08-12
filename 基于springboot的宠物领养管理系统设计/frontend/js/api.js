// API基础配置
const API_BASE_URL = 'http://localhost:8080/api';

// 通用API请求函数
async function apiRequest(endpoint, options = {}) {
    const url = `${API_BASE_URL}${endpoint}`;
    
    const defaultOptions = {
        headers: {
            'Content-Type': 'application/json',
        },
        credentials: 'include', // 包含cookies
    };
    
    const finalOptions = { ...defaultOptions, ...options };
    
    try {
        const response = await fetch(url, finalOptions);
        const data = await response.json();
        
        if (!response.ok) {
            throw new Error(data.message || `HTTP ${response.status}`);
        }
        
        return data;
    } catch (error) {
        console.error('API请求失败:', error);
        throw error;
    }
}

// 用户相关API
const UserAPI = {
    // 用户登录
    login: async (username, password) => {
        return apiRequest('/api/users/login', {
            method: 'POST',
            body: JSON.stringify({ username, password })
        });
    },
    
    // 用户注册
    register: async (userData) => {
        return apiRequest('/api/users/register', {
            method: 'POST',
            body: JSON.stringify(userData)
        });
    },
    
    // 用户登出
    logout: async () => {
        return apiRequest('/api/users/logout', {
            method: 'POST'
        });
    },
    
    // 获取当前用户信息
    getCurrentUser: async () => {
        return apiRequest('/api/users/current');
    },
    
    // 获取所有用户（管理员）
    getAllUsers: async () => {
        return apiRequest('/api/users');
    },
    
    // 更新用户信息
    updateUser: async (userId, userData) => {
        return apiRequest(`/api/users/${userId}`, {
            method: 'PUT',
            body: JSON.stringify(userData)
        });
    },
    
    // 删除用户（管理员）
    deleteUser: async (userId) => {
        return apiRequest(`/api/users/${userId}`, {
            method: 'DELETE'
        });
    }
};

// 宠物相关API
const PetAPI = {
    // 获取宠物列表
    getPets: async (params = {}) => {
        const queryString = new URLSearchParams(params).toString();
        return apiRequest(`/api/pets?${queryString}`);
    },
    
    // 获取宠物详情
    getPetById: async (petId) => {
        return apiRequest(`/api/pets/${petId}`);
    },
    
    // 创建宠物
    createPet: async (petData) => {
        return apiRequest('/api/pets', {
            method: 'POST',
            body: JSON.stringify(petData)
        });
    },
    
    // 更新宠物
    updatePet: async (petId, petData) => {
        return apiRequest(`/api/pets/${petId}`, {
            method: 'PUT',
            body: JSON.stringify(petData)
        });
    },
    
    // 删除宠物
    deletePet: async (petId) => {
        return apiRequest(`/api/pets/${petId}`, {
            method: 'DELETE'
        });
    },
    
    // 获取宠物统计数据
    getPetStats: async () => {
        return apiRequest('/api/pets/stats');
    },
    
    // 获取所有宠物品种
    getAllBreeds: async () => {
        return apiRequest('/api/pets/breeds');
    }
};

// 领养申请相关API
const AdoptionAPI = {
    // 获取所有申请（管理员）
    getAllApplications: async () => {
        return apiRequest('/api/adoption/applications');
    },
    
    // 获取我的申请
    getMyApplications: async () => {
        return apiRequest('/api/adoption/my-applications');
    },
    
    // 检查是否已申请
    checkApplication: async (petId) => {
        return apiRequest(`/api/adoption/check-application/${petId}`);
    },
    
    // 提交申请
    submitApplication: async (applicationData) => {
        return apiRequest('/api/adoption/apply', {
            method: 'POST',
            body: JSON.stringify(applicationData)
        });
    },
    
    // 获取申请详情
    getApplicationDetail: async (applicationId) => {
        return apiRequest(`/api/adoption/application/${applicationId}`);
    },
    
    // 审批申请 - 通过
    approveApplication: async (applicationId, adminNotes) => {
        return apiRequest(`/api/adoption/approve/${applicationId}`, {
            method: 'POST',
            body: JSON.stringify({ adminNotes })
        });
    },
    
    // 审批申请 - 拒绝
    rejectApplication: async (applicationId, adminNotes) => {
        return apiRequest(`/api/adoption/reject/${applicationId}`, {
            method: 'POST',
            body: JSON.stringify({ adminNotes })
        });
    },
    
    // 删除申请
    deleteApplication: async (applicationId) => {
        return apiRequest(`/api/adoption/application/${applicationId}`, {
            method: 'DELETE'
        });
    },
    
    // 获取申请统计数据
    getAdoptionStats: async () => {
        return apiRequest('/api/adoption/stats');
    }
};

// 系统信息相关API
const SystemAPI = {
    // 获取系统信息（管理员）
    getSystemInfo: async () => {
        return apiRequest('/api/system/info');
    }
};

// 工具函数
const Utils = {
    // 显示消息提示
    showMessage: (title, message, type = 'info') => {
        const toast = document.getElementById('messageToast');
        const toastTitle = document.getElementById('toastTitle');
        const toastMessage = document.getElementById('toastMessage');
        
        toastTitle.textContent = title;
        toastMessage.textContent = message;
        
        // 设置样式
        toast.className = `toast ${type === 'error' ? 'bg-danger text-white' : 
                                      type === 'success' ? 'bg-success text-white' : 
                                      type === 'warning' ? 'bg-warning' : 'bg-info text-white'}`;
        
        const bsToast = new bootstrap.Toast(toast);
        bsToast.show();
    },
    
    // 格式化日期
    formatDate: (dateString) => {
        if (!dateString) return '';
        const date = new Date(dateString);
        return date.toLocaleDateString('zh-CN', {
            year: 'numeric',
            month: '2-digit',
            day: '2-digit',
            hour: '2-digit',
            minute: '2-digit'
        });
    },
    
    // 获取状态徽章HTML
    getStatusBadge: (status) => {
        const statusMap = {
            'AVAILABLE': '<span class="badge bg-success">可领养</span>',
            'ADOPTED': '<span class="badge bg-secondary">已领养</span>',
            'PENDING': '<span class="badge bg-warning">待审核</span>',
            'UNAVAILABLE': '<span class="badge bg-danger">不可用</span>',
            'PENDING_APP': '<span class="badge bg-warning">待审核</span>',
            'APPROVED': '<span class="badge bg-success">已通过</span>',
            'REJECTED': '<span class="badge bg-danger">已拒绝</span>'
        };
        return statusMap[status] || '<span class="badge bg-secondary">未知</span>';
    },
    
    // 获取性别徽章HTML
    getGenderBadge: (gender) => {
        const genderMap = {
            'MALE': '<span class="badge bg-primary">公</span>',
            'FEMALE': '<span class="badge" style="background-color: #e83e8c;">母</span>',
            'UNKNOWN': '<span class="badge bg-secondary">未知</span>'
        };
        return genderMap[gender] || '<span class="text-muted">-</span>';
    },
    
    // 获取体型徽章HTML
    getSizeBadge: (size) => {
        const sizeMap = {
            'SMALL': '<span class="badge bg-info">小型</span>',
            'MEDIUM': '<span class="badge bg-warning">中型</span>',
            'LARGE': '<span class="badge bg-danger">大型</span>'
        };
        return sizeMap[size] || '<span class="text-muted">-</span>';
    },
    
    // 获取健康状况徽章HTML
    getHealthBadge: (health) => {
        const healthMap = {
            'EXCELLENT': '<span class="badge bg-success">优秀</span>',
            'GOOD': '<span class="badge bg-primary">良好</span>',
            'FAIR': '<span class="badge bg-warning">一般</span>',
            'POOR': '<span class="badge bg-danger">较差</span>'
        };
        return healthMap[health] || '<span class="text-muted">-</span>';
    },
    
    // 生成分页HTML
    generatePagination: (currentPage, totalPages, onPageChange) => {
        if (totalPages <= 1) return '';
        
        let paginationHTML = '<ul class="pagination justify-content-center">';
        
        // 首页
        if (currentPage > 1) {
            paginationHTML += `<li class="page-item">
                <a class="page-link" href="#" onclick="event.preventDefault(); onPageChange(1)">
                    <i class="fas fa-angle-double-left"></i> 首页
                </a>
            </li>`;
        }
        
        // 上一页
        if (currentPage > 1) {
            paginationHTML += `<li class="page-item">
                <a class="page-link" href="#" onclick="event.preventDefault(); onPageChange(${currentPage - 1})">
                    <i class="fas fa-chevron-left"></i> 上一页
                </a>
            </li>`;
        }
        
        // 页码
        const startPage = Math.max(1, currentPage - 2);
        const endPage = Math.min(totalPages, currentPage + 2);
        
        for (let i = startPage; i <= endPage; i++) {
            paginationHTML += `<li class="page-item ${i === currentPage ? 'active' : ''}">
                <a class="page-link" href="#" onclick="event.preventDefault(); onPageChange(${i})">${i}</a>
            </li>`;
        }
        
        // 下一页
        if (currentPage < totalPages) {
            paginationHTML += `<li class="page-item">
                <a class="page-link" href="#" onclick="event.preventDefault(); onPageChange(${currentPage + 1})">
                    下一页 <i class="fas fa-chevron-right"></i>
                </a>
            </li>`;
        }
        
        // 末页
        if (currentPage < totalPages) {
            paginationHTML += `<li class="page-item">
                <a class="page-link" href="#" onclick="event.preventDefault(); onPageChange(${totalPages})">
                    末页 <i class="fas fa-angle-double-right"></i>
                </a>
            </li>`;
        }
        
        paginationHTML += '</ul>';
        return paginationHTML;
    },
    
    // 显示加载动画
    showLoading: (container) => {
        container.innerHTML = `
            <div class="loading">
                <div class="loading-spinner"></div>
            </div>
        `;
    },
    
    // 显示空状态
    showEmptyState: (container, message, icon = 'fas fa-inbox') => {
        container.innerHTML = `
            <div class="empty-state">
                <i class="${icon}"></i>
                <h4>暂无数据</h4>
                <p>${message}</p>
            </div>
        `;
    }
};

// 导出API对象
window.UserAPI = UserAPI;
window.PetAPI = PetAPI;
window.AdoptionAPI = AdoptionAPI;
window.Utils = Utils; 