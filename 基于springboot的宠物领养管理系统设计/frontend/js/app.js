// 应用状态管理
let currentUser = null;
let currentPage = 1;
let searchParams = {};

// 页面初始化
document.addEventListener('DOMContentLoaded', function() {
    console.log('应用初始化...');
    
    // 检查用户登录状态
    checkAuthStatus();
    
    // 绑定事件监听器
    bindEventListeners();
    
    // 默认显示宠物列表
    showPets();
});

// 绑定事件监听器
function bindEventListeners() {
    // 登录表单提交
    document.getElementById('loginFormElement').addEventListener('submit', handleLogin);
    
    // 注册表单提交
    document.getElementById('registerFormElement').addEventListener('submit', handleRegister);
}

// 检查认证状态
async function checkAuthStatus() {
    try {
        const response = await UserAPI.getCurrentUser();
        if (response.success) {
            currentUser = response.user;
            updateUIForLoggedInUser();
        } else {
            updateUIForLoggedOutUser();
        }
    } catch (error) {
        console.log('用户未登录');
        updateUIForLoggedOutUser();
    }
}

// 更新已登录用户的UI
function updateUIForLoggedInUser() {
    document.getElementById('loginSection').style.display = 'none';
    document.getElementById('registerSection').style.display = 'none';
    document.getElementById('userSection').style.display = 'block';
    
    const userInfo = document.getElementById('userInfo');
    userInfo.textContent = `欢迎，${currentUser.username}`;
    
    // 如果是管理员，显示管理员功能
    if (currentUser.role === 'ADMIN') {
        document.querySelectorAll('.admin-only').forEach(el => {
            el.style.display = 'block';
        });
    }
}

// 更新未登录用户的UI
function updateUIForLoggedOutUser() {
    document.getElementById('loginSection').style.display = 'block';
    document.getElementById('registerSection').style.display = 'block';
    document.getElementById('userSection').style.display = 'none';
    
    document.querySelectorAll('.admin-only').forEach(el => {
        el.style.display = 'none';
    });
}

// 处理登录
async function handleLogin(event) {
    event.preventDefault();
    
    const username = document.getElementById('loginUsername').value;
    const password = document.getElementById('loginPassword').value;
    
    try {
        const response = await UserAPI.login(username, password);
        if (response.success) {
            currentUser = response.user;
            updateUIForLoggedInUser();
            Utils.showMessage('登录成功', '欢迎回来！', 'success');
            hideAllSections();
            showPets();
        }
    } catch (error) {
        Utils.showMessage('登录失败', error.message, 'error');
    }
}

// 处理注册
async function handleRegister(event) {
    event.preventDefault();
    
    const username = document.getElementById('registerUsername').value;
    const email = document.getElementById('registerEmail').value;
    const password = document.getElementById('registerPassword').value;
    const confirmPassword = document.getElementById('registerConfirmPassword').value;
    
    if (password !== confirmPassword) {
        Utils.showMessage('注册失败', '两次输入的密码不一致', 'error');
        return;
    }
    
    try {
        const response = await UserAPI.register({
            username,
            email,
            password,
            role: 'USER'
        });
        
        if (response.success) {
            Utils.showMessage('注册成功', '请登录您的账户', 'success');
            showLogin();
        }
    } catch (error) {
        Utils.showMessage('注册失败', error.message, 'error');
    }
}

// 用户登出
async function logout() {
    try {
        await UserAPI.logout();
        currentUser = null;
        updateUIForLoggedOutUser();
        Utils.showMessage('登出成功', '您已成功登出', 'success');
        hideAllSections();
        showLogin();
    } catch (error) {
        Utils.showMessage('登出失败', error.message, 'error');
    }
}

// 隐藏所有内容区域
function hideAllSections() {
    document.getElementById('loginForm').style.display = 'none';
    document.getElementById('registerForm').style.display = 'none';
    document.getElementById('petsSection').style.display = 'none';
    document.getElementById('myApplicationsSection').style.display = 'none';
    document.getElementById('allApplicationsSection').style.display = 'none';
    document.getElementById('userManagementSection').style.display = 'none';
    document.getElementById('systemInfoSection').style.display = 'none';
}

// 显示登录表单
function showLogin() {
    hideAllSections();
    document.getElementById('loginForm').style.display = 'block';
}

// 显示注册表单
function showRegister() {
    hideAllSections();
    document.getElementById('registerForm').style.display = 'block';
}

// 显示宠物列表
async function showPets() {
    hideAllSections();
    document.getElementById('petsSection').style.display = 'block';
    
    try {
        await loadPets();
        await loadBreeds();
        await loadPetStats();
    } catch (error) {
        Utils.showMessage('加载失败', error.message, 'error');
    }
}

// 加载宠物列表
async function loadPets() {
    const petsGrid = document.getElementById('petsGrid');
    Utils.showLoading(petsGrid);
    
    try {
        const params = {
            page: currentPage,
            size: 12,
            ...searchParams
        };
        
        const response = await PetAPI.getPets(params);
        
        if (response.success) {
            renderPets(response.pets);
            renderPagination(response.currentPage, response.totalPages);
        }
    } catch (error) {
        Utils.showEmptyState(petsGrid, '加载宠物列表失败', 'fas fa-exclamation-triangle');
    }
}

// 渲染宠物列表
function renderPets(pets) {
    const petsGrid = document.getElementById('petsGrid');
    
    if (!pets || pets.length === 0) {
        Utils.showEmptyState(petsGrid, '暂无宠物数据', 'fas fa-paw');
        return;
    }
    
    let html = '';
    pets.forEach(pet => {
        html += `
            <div class="col-md-4 col-lg-3 mb-4">
                <div class="card pet-card">
                    <img src="${pet.images && pet.images.length > 0 ? pet.images[0].imageUrl : 'https://via.placeholder.com/300x200?text=宠物照片'}" 
                         class="card-img-top" alt="${pet.name}">
                    <div class="card-body">
                        <h5 class="card-title">${pet.name}</h5>
                        <p class="card-text">
                            <strong>品种:</strong> ${pet.breed ? pet.breed.name : '未知'}<br>
                            <strong>性别:</strong> ${Utils.getGenderBadge(pet.gender)}<br>
                            <strong>状态:</strong> ${Utils.getStatusBadge(pet.status)}
                        </p>
                        <div class="d-flex justify-content-between">
                            <button class="btn btn-primary btn-sm" onclick="viewPetDetail(${pet.petId})">
                                <i class="fas fa-eye me-1"></i>查看详情
                            </button>
                            ${pet.status === 'AVAILABLE' ? 
                                `<button class="btn btn-success btn-sm" onclick="showAdoptionModal(${pet.petId})">
                                    <i class="fas fa-heart me-1"></i>申请领养
                                </button>` : ''
                            }
                        </div>
                    </div>
                </div>
            </div>
        `;
    });
    
    petsGrid.innerHTML = html;
}

// 渲染分页
function renderPagination(currentPage, totalPages) {
    const paginationContainer = document.getElementById('pagination');
    paginationContainer.innerHTML = Utils.generatePagination(currentPage, totalPages, (page) => {
        currentPage = page;
        loadPets();
    });
}

// 加载宠物品种
async function loadBreeds() {
    try {
        const response = await PetAPI.getAllBreeds();
        if (response.success) {
            const breedFilter = document.getElementById('breedFilter');
            breedFilter.innerHTML = '<option value="">全部品种</option>';
            
            response.breeds.forEach(breed => {
                breedFilter.innerHTML += `<option value="${breed.breedId}">${breed.breedName}</option>`;
            });
        }
    } catch (error) {
        console.error('加载宠物品种失败:', error);
    }
}

// 加载宠物统计数据
async function loadPetStats() {
    try {
        const response = await PetAPI.getPetStats();
        if (response.success) {
            // 这里可以添加统计数据的显示
            console.log('宠物统计数据:', response.stats);
        }
    } catch (error) {
        console.error('加载统计数据失败:', error);
    }
}

// 搜索宠物
function searchPets() {
    const keyword = document.getElementById('searchKeyword').value;
    const breedId = document.getElementById('breedFilter').value;
    const status = document.getElementById('statusFilter').value;
    const gender = document.getElementById('genderFilter').value;
    
    searchParams = {};
    if (keyword) searchParams.keyword = keyword;
    if (breedId) searchParams.breedId = breedId;
    if (status) searchParams.status = status;
    if (gender) searchParams.gender = gender;
    
    currentPage = 1;
    loadPets();
}

// 重置搜索
function resetSearch() {
    document.getElementById('searchKeyword').value = '';
    document.getElementById('breedFilter').value = '';
    document.getElementById('statusFilter').value = '';
    document.getElementById('genderFilter').value = '';
    
    searchParams = {};
    currentPage = 1;
    loadPets();
}

// 显示添加宠物模态框
function showAddPetModal() {
    if (!currentUser || currentUser.role !== 'ADMIN') {
        Utils.showMessage('权限不足', '只有管理员可以添加宠物', 'error');
        return;
    }
    
    const modal = new bootstrap.Modal(document.getElementById('addPetModal'));
    modal.show();
}

// 添加宠物
async function addPet() {
    const petData = {
        name: document.getElementById('petName').value,
        breedId: parseInt(document.getElementById('petBreed').value),
        gender: document.getElementById('petGender').value,
        color: document.getElementById('petColor').value,
        size: document.getElementById('petSize').value,
        status: document.getElementById('petStatus').value,
        description: document.getElementById('petDescription').value
    };
    
    try {
        const response = await PetAPI.createPet(petData);
        if (response.success) {
            Utils.showMessage('添加成功', '宠物添加成功！', 'success');
            bootstrap.Modal.getInstance(document.getElementById('addPetModal')).hide();
            loadPets();
        }
    } catch (error) {
        Utils.showMessage('添加失败', error.message, 'error');
    }
}

// 显示申请领养模态框
async function showAdoptionModal(petId) {
    if (!currentUser) {
        Utils.showMessage('请先登录', '请登录后再申请领养', 'error');
        return;
    }
    
    try {
        // 检查是否已经申请过
        const checkResponse = await AdoptionAPI.checkApplication(petId);
        if (checkResponse.hasApplied) {
            Utils.showMessage('申请失败', '您已经申请过这个宠物了', 'error');
            return;
        }
        
        // 获取宠物信息
        const petResponse = await PetAPI.getPetById(petId);
        if (petResponse.success) {
            const pet = petResponse.pet;
            
            document.getElementById('adoptionPetId').value = petId;
            document.getElementById('petName').textContent = pet.name;
            document.getElementById('petDescription').textContent = pet.description || '暂无描述';
            document.getElementById('petImage').src = pet.images && pet.images.length > 0 ? 
                pet.images[0].imageUrl : 'https://via.placeholder.com/300x200?text=宠物照片';
            
            const modal = new bootstrap.Modal(document.getElementById('adoptionModal'));
            modal.show();
        }
    } catch (error) {
        Utils.showMessage('加载失败', error.message, 'error');
    }
}

// 提交领养申请
async function submitAdoption() {
    const petId = document.getElementById('adoptionPetId').value;
    const applicationText = document.getElementById('applicationText').value;
    const homeDescription = document.getElementById('homeDescription').value;
    const experience = document.getElementById('experience').value;
    
    if (!applicationText.trim() || !homeDescription.trim()) {
        Utils.showMessage('申请失败', '请填写申请理由和家庭环境描述', 'error');
        return;
    }
    
    try {
        const response = await AdoptionAPI.submitApplication({
            petId: parseInt(petId),
            applicationText,
            homeDescription,
            experience
        });
        
        if (response.success) {
            Utils.showMessage('申请成功', '申请提交成功，请等待审核', 'success');
            bootstrap.Modal.getInstance(document.getElementById('adoptionModal')).hide();
        }
    } catch (error) {
        Utils.showMessage('申请失败', error.message, 'error');
    }
}

// 显示我的申请
async function showMyApplications() {
    if (!currentUser) {
        Utils.showMessage('请先登录', '请登录后查看申请', 'error');
        return;
    }
    
    hideAllSections();
    document.getElementById('myApplicationsSection').style.display = 'block';
    
    try {
        const response = await AdoptionAPI.getMyApplications();
        if (response.success) {
            renderMyApplications(response.applications);
        }
    } catch (error) {
        Utils.showMessage('加载失败', error.message, 'error');
    }
}

// 渲染我的申请
function renderMyApplications(applications) {
    const container = document.getElementById('myApplicationsList');
    
    if (!applications || applications.length === 0) {
        Utils.showEmptyState(container, '您还没有提交过申请', 'fas fa-heart');
        return;
    }
    
    let html = '';
    applications.forEach(app => {
        html += `
            <div class="application-card">
                <div class="d-flex justify-content-between align-items-start">
                    <div>
                        <h5>申请ID: ${app.applicationId}</h5>
                        <p><strong>申请时间:</strong> ${Utils.formatDate(app.createdAt)}</p>
                        <p><strong>申请理由:</strong> ${app.applicationText}</p>
                        <p><strong>家庭环境:</strong> ${app.homeDescription}</p>
                        ${app.experience ? `<p><strong>养宠经验:</strong> ${app.experience}</p>` : ''}
                    </div>
                    <div>
                        ${Utils.getStatusBadge(app.status)}
                    </div>
                </div>
                ${app.adminNotes ? `<div class="mt-3"><strong>管理员意见:</strong> ${app.adminNotes}</div>` : ''}
            </div>
        `;
    });
    
    container.innerHTML = html;
}

// 显示所有申请（管理员）
async function showAllApplications() {
    if (!currentUser || currentUser.role !== 'ADMIN') {
        Utils.showMessage('权限不足', '只有管理员可以查看所有申请', 'error');
        return;
    }
    
    hideAllSections();
    document.getElementById('allApplicationsSection').style.display = 'block';
    
    try {
        const response = await AdoptionAPI.getAllApplications();
        if (response.success) {
            renderAllApplications(response.applications);
        }
    } catch (error) {
        Utils.showMessage('加载失败', error.message, 'error');
    }
}

// 渲染所有申请
function renderAllApplications(applications) {
    const container = document.getElementById('allApplicationsList');
    
    if (!applications || applications.length === 0) {
        Utils.showEmptyState(container, '暂无申请数据', 'fas fa-list');
        return;
    }
    
    let html = `
        <div class="table-responsive">
            <table class="table">
                <thead>
                    <tr>
                        <th>申请ID</th>
                        <th>申请人</th>
                        <th>宠物名称</th>
                        <th>申请时间</th>
                        <th>状态</th>
                        <th>操作</th>
                    </tr>
                </thead>
                <tbody>
    `;
    
    applications.forEach(app => {
        html += `
            <tr>
                <td>${app.applicationId}</td>
                <td>${app.userId}</td>
                <td>${app.petId}</td>
                <td>${Utils.formatDate(app.createdAt)}</td>
                <td>${Utils.getStatusBadge(app.status)}</td>
                <td>
                    <button class="btn btn-primary btn-sm" onclick="viewApplicationDetail(${app.applicationId})">
                        <i class="fas fa-eye me-1"></i>查看
                    </button>
                    ${app.status === 'PENDING' ? `
                        <button class="btn btn-success btn-sm" onclick="approveApplication(${app.applicationId})">
                            <i class="fas fa-check me-1"></i>通过
                        </button>
                        <button class="btn btn-danger btn-sm" onclick="rejectApplication(${app.applicationId})">
                            <i class="fas fa-times me-1"></i>拒绝
                        </button>
                    ` : ''}
                </td>
            </tr>
        `;
    });
    
    html += `
                </tbody>
            </table>
        </div>
    `;
    
    container.innerHTML = html;
}

// 显示用户管理（管理员）
async function showUserManagement() {
    if (!currentUser || currentUser.role !== 'ADMIN') {
        Utils.showMessage('权限不足', '只有管理员可以管理用户', 'error');
        return;
    }
    
    hideAllSections();
    document.getElementById('userManagementSection').style.display = 'block';
    
    try {
        const response = await UserAPI.getAllUsers();
        if (response.success) {
            renderUserManagement(response.users);
        }
    } catch (error) {
        Utils.showMessage('加载失败', error.message, 'error');
    }
}

// 渲染用户管理
function renderUserManagement(users) {
    const container = document.getElementById('userManagementList');
    
    if (!users || users.length === 0) {
        Utils.showEmptyState(container, '暂无用户数据', 'fas fa-users');
        return;
    }
    
    let html = `
        <div class="table-responsive">
            <table class="table">
                <thead>
                    <tr>
                        <th>用户ID</th>
                        <th>用户名</th>
                        <th>邮箱</th>
                        <th>角色</th>
                        <th>注册时间</th>
                        <th>操作</th>
                    </tr>
                </thead>
                <tbody>
    `;
    
    users.forEach(user => {
        html += `
            <tr>
                <td>${user.userId}</td>
                <td>${user.username}</td>
                <td>${user.email}</td>
                <td><span class="badge ${user.role === 'ADMIN' ? 'bg-danger' : 'bg-primary'}">${user.role}</span></td>
                <td>${Utils.formatDate(user.createdAt)}</td>
                <td>
                    <button class="btn btn-primary btn-sm" onclick="editUser(${user.userId})">
                        <i class="fas fa-edit me-1"></i>编辑
                    </button>
                    ${user.userId !== currentUser.userId ? `
                        <button class="btn btn-danger btn-sm" onclick="deleteUser(${user.userId})">
                            <i class="fas fa-trash me-1"></i>删除
                        </button>
                    ` : ''}
                </td>
            </tr>
        `;
    });
    
    html += `
                </tbody>
            </table>
        </div>
    `;
    
    container.innerHTML = html;
}

// 查看宠物详情
function viewPetDetail(petId) {
    // 这里可以实现查看宠物详情的功能
    Utils.showMessage('功能开发中', '宠物详情功能正在开发中', 'info');
}

// 查看申请详情
function viewApplicationDetail(applicationId) {
    // 这里可以实现查看申请详情的功能
    Utils.showMessage('功能开发中', '申请详情功能正在开发中', 'info');
}

// 审批申请
function approveApplication(applicationId) {
    const adminNotes = prompt('请输入审批意见（可选）:');
    
    AdoptionAPI.approveApplication(applicationId, adminNotes || '')
        .then(response => {
            if (response.success) {
                Utils.showMessage('审批成功', '申请已通过', 'success');
                showAllApplications();
            }
        })
        .catch(error => {
            Utils.showMessage('审批失败', error.message, 'error');
        });
}

// 拒绝申请
function rejectApplication(applicationId) {
    const adminNotes = prompt('请输入拒绝原因（必填）:');
    
    if (!adminNotes || adminNotes.trim() === '') {
        Utils.showMessage('拒绝失败', '请输入拒绝原因', 'error');
        return;
    }
    
    AdoptionAPI.rejectApplication(applicationId, adminNotes)
        .then(response => {
            if (response.success) {
                Utils.showMessage('操作成功', '申请已拒绝', 'success');
                showAllApplications();
            }
        })
        .catch(error => {
            Utils.showMessage('操作失败', error.message, 'error');
        });
}

// 编辑用户
function editUser(userId) {
    Utils.showMessage('功能开发中', '编辑用户功能正在开发中', 'info');
}

// 删除用户
function deleteUser(userId) {
    if (confirm('确定要删除这个用户吗？')) {
        UserAPI.deleteUser(userId)
            .then(response => {
                if (response.success) {
                    Utils.showMessage('删除成功', '用户已删除', 'success');
                    showUserManagement();
                }
            })
            .catch(error => {
                Utils.showMessage('删除失败', error.message, 'error');
            });
    }
}

// 显示系统信息（管理员）
async function showSystemInfo() {
    if (!currentUser || currentUser.role !== 'ADMIN') {
        Utils.showMessage('权限不足', '只有管理员可以查看系统信息', 'error');
        return;
    }
    
    hideAllSections();
    document.getElementById('systemInfoSection').style.display = 'block';
    
    try {
        const response = await SystemAPI.getSystemInfo();
        if (response.success) {
            renderSystemInfo(response.systemInfo);
        }
    } catch (error) {
        Utils.showMessage('加载失败', error.message, 'error');
    }
}

// 渲染系统信息
function renderSystemInfo(systemInfo) {
    const container = document.getElementById('systemInfoContent');
    
    const memoryInfo = systemInfo.memoryInfo;
    
    let html = `
        <div class="row">
            <!-- 基本信息 -->
            <div class="col-md-6 mb-4">
                <div class="card">
                    <div class="card-header">
                        <h5><i class="fas fa-info-circle me-2"></i>基本信息</h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-6">
                                <strong>版本：</strong><br>
                                <span class="text-muted">${systemInfo.version}</span>
                            </div>
                            <div class="col-6">
                                <strong>构建日期：</strong><br>
                                <span class="text-muted">${systemInfo.buildDate}</span>
                            </div>
                        </div>
                        <hr>
                        <div class="row">
                            <div class="col-6">
                                <strong>Java版本：</strong><br>
                                <span class="text-muted">${systemInfo.javaVersion}</span>
                            </div>
                            <div class="col-6">
                                <strong>操作系统：</strong><br>
                                <span class="text-muted">${systemInfo.osName} ${systemInfo.osVersion}</span>
                            </div>
                        </div>
                        <hr>
                        <div class="row">
                            <div class="col-6">
                                <strong>系统架构：</strong><br>
                                <span class="text-muted">${systemInfo.osArch}</span>
                            </div>
                            <div class="col-6">
                                <strong>文件编码：</strong><br>
                                <span class="text-muted">${systemInfo.fileEncoding}</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- 内存信息 -->
            <div class="col-md-6 mb-4">
                <div class="card">
                    <div class="card-header">
                        <h5><i class="fas fa-memory me-2"></i>内存使用</h5>
                    </div>
                    <div class="card-body">
                        <div class="mb-3">
                            <div class="d-flex justify-content-between">
                                <span>内存使用率</span>
                                <span>${memoryInfo.memoryUsage}%</span>
                            </div>
                            <div class="progress">
                                <div class="progress-bar" role="progressbar" 
                                     style="width: ${memoryInfo.memoryUsage}%" 
                                     aria-valuenow="${memoryInfo.memoryUsage}" 
                                     aria-valuemin="0" aria-valuemax="100">
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-6">
                                <strong>总内存：</strong><br>
                                <span class="text-muted">${memoryInfo.totalMemory}</span>
                            </div>
                            <div class="col-6">
                                <strong>已用内存：</strong><br>
                                <span class="text-muted">${memoryInfo.usedMemory}</span>
                            </div>
                        </div>
                        <hr>
                        <div class="row">
                            <div class="col-6">
                                <strong>空闲内存：</strong><br>
                                <span class="text-muted">${memoryInfo.freeMemory}</span>
                            </div>
                            <div class="col-6">
                                <strong>最大内存：</strong><br>
                                <span class="text-muted">${memoryInfo.maxMemory}</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="row">
            <!-- 路径信息 -->
            <div class="col-md-12 mb-4">
                <div class="card">
                    <div class="card-header">
                        <h5><i class="fas fa-folder me-2"></i>路径信息</h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-4">
                                <strong>用户目录：</strong><br>
                                <span class="text-muted">${systemInfo.userHome}</span>
                            </div>
                            <div class="col-md-4">
                                <strong>工作目录：</strong><br>
                                <span class="text-muted">${systemInfo.userDir}</span>
                            </div>
                            <div class="col-md-4">
                                <strong>Java目录：</strong><br>
                                <span class="text-muted">${systemInfo.javaHome}</span>
                            </div>
                        </div>
                        <hr>
                        <div class="row">
                            <div class="col-md-6">
                                <strong>时区：</strong><br>
                                <span class="text-muted">${systemInfo.timeZone}</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    `;
    
    container.innerHTML = html;
} 