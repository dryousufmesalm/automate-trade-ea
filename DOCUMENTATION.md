# Automate Trade EA – Documentation

## Overview

Automate Trade EA uses the YM library to automate trading on MetaTrader 5. It handles orders and positions so you can focus on strategy logic.

## Logic

Runs on OnTick (and any timer/events in the source). Uses YM for open/modify/close. Entry/exit rules are in the source; magic number identifies this EA's trades.

## Parameters

See the Inputs tab when attaching: typically Lot size, Magic number, and strategy-specific options.

## Features

- YM-based execution; configurable inputs; works on single or multiple charts with different magic numbers.

## Risks and limitations

No guarantee of profitability. Depends on YM and broker execution. Use on demo first. Not responsible for trading losses.

---

**Yousuf Mesalm** – [www.yousufmesalm.com](https://www.yousufmesalm.com) · WhatsApp: +201006179048 · [Upwork](https://www.upwork.com/freelancers/youssefmesalm)
