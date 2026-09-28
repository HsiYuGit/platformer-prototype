# 驗證紀錄

環境：Windows / Godot 4.6.1，沒有 Web export templates。
分為原生物理測試、原生渲染與瀏覽器檢視渲染紀錄；後者不等同可互動 Web 版。
檢查入口、checkpoint、技能隔離、碰撞、重試、完成、禁用技能對照與縮放。
自動路徑從 checkpoint 起點開始，使用 Input action 與真正 move_and_slide，不能靠傳送到出口判定可通關。
自動路徑只證明可行，不代表玩家已確認好玩或難度合適。

初始 headless editor 在 sandbox 出現 root certificate store 與 editor settings 寫入錯誤，是環境診斷，需與遊戲錯誤區分。

基礎入口 checkpoint：原生路徑從起點 4.37 秒通過基準關，重試／禁用技能／回入口狀態檢查通過。原生 renderer 輸出 hub.png、baseline-1.png，terminal 無程式錯誤。使用正常權限與指定 log-file 後初始環境錯誤不再出現。瀏覽器工具拒絕 file 協定，遵守限制改用原生 render smoke 與本機圖像檢視，未聲稱完成 Web 互動驗證。

衝刺：三段從起點零重試通過（3.88 / 2.88 / 2.85 秒）。第二段確實落小島後再次跳躍衝刺。調整衝刺結束回到基礎速度，避免殘餘高速使小島落點失控。原生三段渲染與 log 檢查通過。C/V 提供同幾何規則對照，改規則不計預設通關。

二段跳：高台／長坑／低天花板晚救回路線皆從起點零重試通過（4.67 / 4.42 / 4.52 秒）；最後一段未先起跳仍可使用空中跳。三段原生渲染與 terminal log 通過。

蹬牆：三段原生從起點零重試通過；雙牆路徑含左右交替後轉向出口。測試抓到轉向時接觸判定丟失，增加 0.10 秒可消耗離牆容許後修正。最終原生渲染與 log 通過。

滑翔：長距離、高度窗口、小島落地三段皆從起點零重試通過。高度窗口路徑實際切換開傘與收傘，小島路徑確實落地後再次出發。原生渲染與 terminal log 通過。

鉤索拉近：三段從起點零重試通過（4.13 / 3.87 / 4.13 秒），雙錨點路徑確實 release 再 press，保留真實角色碰撞。原生渲染與 terminal log 通過。

重力反轉：完整天花板、上下交錯障礙、斷續天花板三段皆從起點零重試通過（6.03 / 6.02 / 5.43 秒）。原生渲染與 terminal log 通過。

## 最終回歸 checkpoint

- 19/19 條路徑通過：6 種技能 × 3 段，另加基準關；全部從實際出生點以 Input action 經 move_and_slide 完成，零重試。
- `tests/checks.gd` 的 24 項檢查通過：數字鍵、F3、X、R、B、Esc、Enter、衝刺 C/V 設定、技能資源／限制、死亡補充、鉤索遮擋及 UI 邊界。
- `checks.gd` 的局部物理契約檢查會設定角色位置；它們不作為關卡可通關證據。可通關證據來自獨立的 `playthrough.gd`。
- 1280×720、960×540 皆輸出原生 Godot 渲染，完整入口（含全部通關文字）與 18 段未發現裁切；HUD 增加底色，與紅色危險區分離。
- 最終 `regression.log`、`checks.log`、`render-final.log`、`render-small.log`、`native-ui.log` 未見 ERROR、traceback、request_error 或 500。
- 引擎渲染背景程序均記錄 PID 並以 30 秒上限等待；皆正常結束。原生互動視窗 PID 56288 已停止，確認沒有殘留 Godot 程序。没有啟動 HTTP server。
- Windows UI 自動操作工具在 app approval 等待時逾時，未完成工具控制的真人式連續操作。原生輸入事件測試通過不等於真人手感評測。
- 瀏覽器拒絕本機 file URL，因此未繞過限制或宣稱完成瀏覽器互動測試。此專案交付為 Godot 原生原型。

## 重跑

在專案根目錄先建立 `output/`（已 gitignore），將 `$godot` 指向 Godot 4.6.1 執行檔。
以下 headless 命令是有限測試程序，帶 frame 上限，不是常駐 server。

```powershell
& $godot --headless --path . --log-file output/regression.log --fixed-fps 60 --quit-after 20000 --script tests/playthrough.gd
& $godot --headless --path . --log-file output/checks.log --fixed-fps 60 --quit-after 4000 --script tests/checks.gd
```

單獨關卡在第一個命令後加 `-- dash`，可用 ID 為 `dash`、`double_jump`、`wall_jump`、`glide`、`grapple`、`gravity_flip`。
原生渲染使用 `--script tests/render.gd`；小視窗再加 `--resolution 960x540` 與腳本參數 `-- small`。
渲染測試需 GPU、使用 Start-Process 背景程序並記錄 PID，超過 30 秒停止；正常會輸出 RENDER PASS 並自行退出。
圖像、log、PID 只存在忽略的 `output/`，不加入版本控制。
