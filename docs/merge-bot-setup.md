# Merge Bot 配置

主控使用专用 Merge Bot 和细粒度 Token。Token 只授予读取 Issue/PR/CI/评论、写评论、更新任务标签和 squash merge 所需权限；不得授予组织管理、仓库删除或分支保护修改权限。凭据保存在主控设备的安全凭据存储中，不写入仓库、Issue 或日志。

人工触发主控 Skill 后，它会在 `gh pr merge --squash` 前重新检查 Reviewer 当前 SHA、required CI、Issue 自动验收证据、PR 状态和分支保护。任一失败都写失败评论并保留 PR；下一次人工调用主控时自动重试。
