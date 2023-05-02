@def tabname="Validating Cosmological Contours"
@def title="Validating Cosmological Contours"
@def subtitle="Using frequentist methods for bayesian validation"
@def authors="Armstrong, P.; Qu, H.; et. al."
@def img="/assets/images/validation/Nominal.svg"

@@project
@@fulljustify
# Introduction
Modern supernova cosmological analysis requires a dizzying collection of programs, scripts, and tools in order to effectively measure details of our Universe from exploding stars. Some of these tools include [SNANA](https://github.com/RickKessler/SNANA), [SuperNNova](https://github.com/supernnova/SuperNNova), [CosmoSIS](https://github.com/joezuntz/cosmosis), and [Pippin](https://github.com/dessn/Pippin). Although each of these tools has individually been tested to ensure they work correctly, it's still important to test that when we combine them all together we still get a sensible answer. The final product of a supernova cosmological analysis is often a bayesian contour, which tells us how likely different cosmological parameters are (See Figure 1 for an example of a bayesian contour). What we really want to know is whether this contour is "correct", or in other words, is our combination of tools over or underestimating our cosmological likelihoods?
@@project-figure
@@project-fig
~~~
<img class="project-fig" src="/assets/images/validation/Nominal.svg" alt="Cosmological Contour"></img>
~~~
@@
@@project-caption
Example of a baysian contour. The x-axis shows the different values of $\Omega_{M}$ we are testing, and the y-axis shows the different values of $w_{0}$ we are testing. The central plot shows the likelihood of a set of ($\Omega_{M}$, $w_{0}$) being the true cosmological parameters for our dataset. The top and rightmost plots show this same likelihood, but only for $Omega_{M}$ and $w_{0}$ respectively. The most likely cosmological parameters according to this contour is $\Omega_{M} = 0.32$, and $w_{0} = -1.01$. The uncertainty in these parameters is related to the exact shape of the contour, so in order to make sure our uncertainties are correct, we need to make sure this contour is correct - hence we need to validate the contour.
@@
@@
Previous project, such as [Brout. D.; Scolnic, D.; et. al. (2018)](https://arxiv.org/abs/1811.02377) have validated these contours by running lots of simulations, and showing that "on average" the contour is correct. However, our data is not the average of many different universes, it's a single Universe, so we really want to show that our contours are correct for a single dataset, rather than after averaging over many datasets.

In this project, we aim to provide a method for validating cosmological contours of single datasets. In order to do this, we need a way of calculating the "correct" contour, which we can then compare to our bayesian contour and see how well they match. The method we use to do this is a frequentist method called the Neyman construction. Without getting in to too much detail, the Neyman construction is a way to approximate a contour by doing lots of experiments at different points in your parameter space. What we want to do is use this Neyman contour as a way of validating our bayesian contour.
@@
@@
