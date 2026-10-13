# PDF 彩页黑白页自动分离 · pdf-color-split

> 自动把 PDF 里的彩色页与黑白页拆分，用于打印计价。

## 问题

打印论文/文档时，彩色页与黑白页打印单价不同，需要手动逐页查找彩色页再分开打印，费时且易漏。

## 解决方案

编写批处理脚本（`.bat`），调用 Ghostscript + QPDF 两个开源工具，自动检测页面是否为彩色，把彩色页与黑白页分别输出。

## 结果

一键自动分离彩页与黑白页，打印计价精准，省去手动逐页查找，脚本可复用。

## 文件清单

- `split_picturecolor.bat` — 分离脚本（需配置环境变量）
- `split_picturecolor_no_env.bat` — 无需配置环境变量的版本
- `020 两种路径设置都可以.txt` — 路径设置说明
- `021方法一 步骤 环境变量/` — 环境变量配置截图步骤

## 使用方式

1. 安装 [Ghostscript](https://ghostscript.com/releases/gsdnld.html) 与 [QPDF](https://github.com/qpdf/qpdf/releases)（安装包不放本仓库）。
2. 按 `020` / `021` 说明配置路径后，运行对应 `.bat`。
