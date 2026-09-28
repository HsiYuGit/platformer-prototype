# 驗證紀錄

環境：Windows / Godot 4.6.1，沒有 Web export templates。
分為原生物理測試、原生渲染與瀏覽器檢視渲染紀錄；後者不等同可互動 Web 版。
檢查入口、checkpoint、技能隔離、碰撞、重試、完成、禁用技能對照與縮放。
自動路徑從 checkpoint 起點開始，使用 Input action 與真正 move_and_slide，不能靠傳送到出口判定可通關。
自動路徑只證明可行，不代表玩家已確認好玩或難度合適。

初始 headless editor 在 sandbox 出現 root certificate store 與 editor settings 寫入錯誤，是環境診斷，需與遊戲錯誤區分。

基礎入口 checkpoint：原生路徑從起點 4.37 秒通過基準關，重試／禁用技能／回入口狀態檢查通過。原生 renderer 輸出 hub.png、baseline-1.png，terminal 無程式錯誤。使用正常權限與指定 log-file 後初始環境錯誤不再出現。瀏覽器工具拒絕 file 協定，遵守限制改用原生 render smoke 與本機圖像檢視，未聲稱完成 Web 互動驗證。

衝刺：三段從起點零重試通過（3.88 / 2.88 / 2.85 秒）。第二段確實落小島後再次跳躍衝刺。調整衝刺結束回到基礎速度，避免殘餘高速使小島落點失控。原生三段渲染與 log 檢查通過。C/V 提供同幾何規則對照，改規則不計預設通關。
