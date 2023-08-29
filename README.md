
<p align="center"><img src="cfilt-dark-vec.png" alt="logo" width="150" height="150"/></p>

# “Let’s not Quote out of Context”: Unified Vision-Language Pretraining for Context Assisted Image Captioning

<p align="center">
        <a href="https://aclanthology.org/2023.acl-industry.67/">Paper </a>&nbsp ｜ <a href="https://iitbacin-my.sharepoint.com/:f:/g/personal/21q050004_iitb_ac_in/Eu6lmwWo0PdKopPfOJ6ZePUBVmLqG8izfnYChvmZ0c2vCw?e=gVFGjI"> Data </a>&nbsp | <a href="https://iitbacin-my.sharepoint.com/:f:/g/personal/21q050004_iitb_ac_in/ElXUdK94M7BNvdCqmIz5zgQBwD4cHYGl1T3uGxV-1itiHA?e=oIVglS"> Checkpoints </a>
</p>



## About
Well-formed context aware image captions and tags in enterprise content such as marketing material are critical to ensure their brand presence and content recall. Manual creation and updates to ensure the same is non trivial given the scale and the tedium towards this task. We propose a new unified Vision-Language (VL) model based on the One For All (OFA) model, with a focus on context-assisted image captioning where the caption is generated based on both the image and its context. Our approach aims to overcome the context-independent (image and text are treated independently) nature of the existing approaches. We exploit context by pretraining our model with datasets of three tasks- news image captioning where the news article is the context, contextual visual entailment, and keyword extraction from the context. The second pretraining task is a new VL task, and we construct and release two datasets for the task with 1.1M and 2.2K data instances. Our system achieves state-of-the-art results with an improvement of up to 8.34 CIDEr score on the benchmark news image captioning datasets. To the best of our knowledge, ours is the first effort at incorporating contextual information in pretraining the models for the VL tasks.

## Usage

Download the checkpoints and data from the external links shared. The instructions to setup the pipeline can be obtained from the original [OFA](https://github.com/OFA-Sys/OFA) repository.


## Contact

For any additional details to reproduce results or to obtain intermediate checkpoints, please contact: `abisekrk`[@]`cse.iitb.ac.in`


## Citation

Please cite our work if you use our data or ideas from the paper

```latex

@inproceedings{Kalarani2023LetsNQ,
  title={“Let’s not Quote out of Context”: Unified Vision-Language Pretraining for Context Assisted Image Captioning},
  author={Abisek Rajakumar Kalarani and Pushpak Bhattacharyya and Niyati Chhaya and Sumit Shekhar},
  booktitle={Annual Meeting of the Association for Computational Linguistics},
  year={2023},
  url={https://api.semanticscholar.org/CorpusID:259000001}
}


```