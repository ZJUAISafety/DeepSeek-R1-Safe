
<p align="left">
  <img src="imgs/cuteicon.png" alt="icon" height="80">
  <img src="imgs/text.png" alt="text" height="80">
</p>

<p align="left">
  <img src="imgs/frameworknew.png" alt="DeepSeek-R1-Safe 框架" width="1000">
</p>

**DeepSeek-R1-Safe**是由浙江大学网络空间安全学院和华为合作的基于DeepSeek衍生的安全大模型，在**华为昇腾芯片**和**MindSpeedLLM**等框架的基础上开发。

该模型的训练流程如下：

1. **训练数据生成**：创新构建了具备多元维度融合、安全价值对齐、越狱攻防强化三大特征的安全训练语料

2. **安全监督训练**：在监督训练过程中提出安全核心思维模式预对齐机制，从而实现快速安全思维引导；同时提出动态感知高效精准补偿机制，补偿性能损失同时不影响安全性能

3. **安全强化学习**：突破传统单一安全约束模式，提出多维细粒度安全奖励信号体系，创新运用性能-安全帕累托最优组合策略，实现了安全与通用能力的协同优化

4. **模型性能评测**：依托多维度测试数据和系统化评测方法，构建全面、可信的大模型安全评测框架

本仓库发布了相关流程介绍，为研究者和开发者提供参考和实践基础。

# 📚 项目介绍

## 🛡️ 安全语料

我们严格依据中国、美国、欧盟等多地域法律与伦理标准进行了安全规则融合，在语料结构中加入了显式安全推理链，并引入了最新越狱攻击方法，丰富了训练样本攻击策略，从而使得模型在实际场景中的安全鲁棒性得到强化。这份高质量的数据集，可用于大模型的**安全训练、微调以及测试**。


## 🔒 安全模型

我们开源了经过安全训练的**DeepSeek-R1满血版模型**。该模型在保持推理性能的同时，显著提升了安全性与合规性。  
模型权重已托管在modelscope魔搭社区上，研究者与开发者可通过以下链接进行访问：  

👉 [DeepSeek-R1-Safe 模型权重](https://www.modelscope.cn/models/ZJUAISafety/DeepSeek-R1-Safe)

## 📁 文件结构  

```text
DeepSeek-R1-Safe
├── Code  # directory for code
│   ├── MindSpeed-LLM  # directory of the specific version of MindSpeed-LLM
├── scripts  # contains running scripts
│   ├── generate_deepseekr1safe_ptd.sh
└── README.md
```

# 运行推理

## 💻 所需硬件环境

运行DeepSeek-R1-Safe推理需要至少8台搭载8卡910B型号显卡的服务器

## 🤖 环境配置

DeepSeek-R1-Safe 的环境依赖如下表所示，具体安装指导请参考：[安装指导](https://gitee.com/ascend/MindSpeed-LLM/tree/7ce6c0c786ac50d77fb348b7b04776e60c1aad8d#/ascend/MindSpeed-LLM/blob/7ce6c0c786ac50d77fb348b7b04776e60c1aad8d/./docs/features/install_guide.md)

| 依赖软件                                                     | 版本     |
| ------------------------------------------------------------ | -------- |
| 昇腾NPU驱动<br>昇腾NPU固件                                   | 在研版本 |
| Toolkit（开发套件）<br>Kernel（算子包）<br>NNAL（Ascend Transformer Boost加速库） | 在研版本 |
| Python                                                       | 3.10     |
| PyTorch                                                      | 2.6      |
| torch_npu插件<br>apex                                        | 在研版本 |

请将链接中[指定版本的MindSpeed-LLM仓库](https://gitee.com/ascend/MindSpeed-LLM/tree/7ce6c0c786ac50d77fb348b7b04776e60c1aad8d#/ascend/MindSpeed-LLM/blob/7ce6c0c786ac50d77fb348b7b04776e60c1aad8d/./docs/features/install_guide.md)置于Code/MindSpeed-LLM。

## 🚀 运行推理脚本

在配置好环境后，请依次在8台服务器上按照实际运行环境修改[推理脚本](scripts/generate_deepseekr1safe_ptd.sh)中的包括但不限于主节点IP、路径等各种参数以及对应的NODE_RANK(从0-7编号，编号0为主节点)<br>

随后在8台服务器上同时运行推理脚本

# 💡 测试示例
<p align="left">
  <img src="imgs/en_eg.png" alt="英文示例" width="1000">
</p>

<p align="left">
  <img src="imgs/zh_eg.png" alt="中文示例" width="1000">
</p>
