% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/perturb_trans.R
\name{perturb_trans}
\alias{perturb_trans}
\title{Perturbation analysis of transition types within a matrix population model}
\usage{
perturb_trans(
  matU,
  matF,
  matC = NULL,
  posU = matU > 0,
  posF = matF > 0,
  posC = matC > 0,
  exclude_row = NULL,
  exclude_col = NULL,
  pert = 1e-06,
  type = "sensitivity",
  demog_stat = "lambda",
  ...
)
}
\arguments{
\item{matU}{The survival component of a matrix population model (i.e. a
square projection matrix reflecting survival-related transitions; e.g.
progression, stasis, and retrogression)}

\item{matF}{The sexual component of a matrix population model (i.e. a square
projection matrix reflecting transitions due to sexual reproduction)}

\item{matC}{The clonal component of a matrix population model (i.e. a square
projection matrix reflecting transitions due to clonal reproduction).
Defaults to \code{NULL}, indicating no clonal reproduction possible.}

\item{posU}{A logical matrix of the same dimension as \code{matU}, with
elements indicating whether a given \code{matU} transition is possible
(\code{TRUE}) or not (\code{FALSE}). Defaults to \code{matU > 0} (see
Details).}

\item{posF}{A logical matrix of the same dimension as \code{matF}, with
elements indicating whether a given \code{matF} transition is possible
(\code{TRUE}) or not (\code{FALSE}). Defaults to \code{matF > 0} (see
Details).}

\item{posC}{A logical matrix of the same dimension as \code{matC}, with
elements indicating whether a given \code{matC} transition is possible
(\code{TRUE}) or not (\code{FALSE}). Defaults to \code{matC > 0} (see
Details).}

\item{exclude_row}{Integer or logical vector indicating stages for which
transitions \emph{to} the stage should be excluded from perturbation
analysis. See section \emph{Excluding stages}.}

\item{exclude_col}{Integer or logical vector indicating stages for which
transitions \emph{from} the stage should be excluded from perturbation
analysis. See section \emph{Excluding stages}.}

\item{pert}{Magnitude of the perturbation (defaults to \code{1e-6})}

\item{type}{Whether to return "sensitivity" or "elasticity" values. Defaults
to "sensitivity'.}

\item{demog_stat}{The demographic statistic to be used, as in "the
sensitivity/elasticity of \code{demog_stat} to matrix element
perturbations." Defaults to the per-capita population growth rate at
equilibrium (\eqn{lambda}). Also accepts a user-supplied function that
performs a calculation on a projection matrix and returns a single numeric
value.}

\item{...}{Additional arguments passed to the function \code{demog_stat}.}
}
\value{
A list with 5 elements:
\item{stasis}{sensitivity or elasticity of \code{demog_stat} to stasis}
\item{retrogression}{sensitivity or elasticity of \code{demog_stat} to
retrogression}
\item{progression}{sensitivity or elasticity of \code{demog_stat} to
progression}
\item{fecundity}{sensitivity or elasticity of \code{demog_stat} to sexual
fecundity}
\item{clonality}{sensitivity or elasticity of \code{demog_stat} to clonality}
}
\description{
Calculates the summed sensitivities or elasticities for various transition
types within a matrix population model, including stasis, retrogression,
progression, fecundity, and clonality.

Sensitivities or elasticities are calculated by perturbing elements of the
matrix population model and measuring the response of the per-capita
population growth rate at equilibrium (\eqn{\lambda}), or, with a
user-supplied function, any other demographic statistic.
}
\details{
A transition rate of \code{0} within a matrix population model may indicate
that the transition is not possible in the given life cycle (e.g. tadpoles
never revert to eggs), or that the transition is possible but was estimated
to be \code{0} in the relevant population and time period. Because transition
rates of zero \emph{do} generally yield non-zero sensitivities, it is
important to distinguish between structural zeros and sampled zeros when
summing multiple sensitivities for a given process (e.g. progression).

By default, the \code{perturb_} functions assume that a transition rate of
\code{0} indicates an impossible transition, in which case the sensitivity
for that transition will not be included in any calculation. Specifically,
the arguments \code{posX} are specified by the logical expression \code{(matX
> 0)}. If the matrix population model includes transitions that are possible
but estimated to be \code{0}, users should specify the \code{posX}
argument(s) manually.

If there are no possible transitions for a given process (e.g. clonality),
the value of sensitivity or elasticity returned for that process will be
\code{NA}
}
\section{Excluding stages}{

It may be desirable to exclude one or more stages from the calculation. For
instance, we might not believe that 'progression' to a dormant stage class
really reflects progression, in which case we could exclude transitions
\emph{to} the dormant stage class using the argument \code{exclude_row}. We
may or may not want to ignore progression transitions \emph{from} the dormant
stage class, which can be done using \code{exclude_col}. The \code{exclude_}
arguments effectively just set the relevant row or column of the \code{posX}
arguments to \code{FALSE}, to prevent those transitions from being used in
subsequent calculations.
}

\examples{
matU <- rbind(c(0.1,   0,   0,   0),
              c(0.5, 0.2, 0.1,   0),
              c(  0, 0.3, 0.3, 0.1),
              c(  0,   0, 0.5, 0.6))

matF <- rbind(c(  0,   0, 1.1, 1.6),
              c(  0,   0, 0.8, 0.4),
              c(  0,   0,   0,   0),
              c(  0,   0,   0,   0))

\dontrun{
perturb_trans(matU, matF)

# use a larger perturbation than the default
perturb_trans(matU, matF, pert = 0.01)

# calculate the sensitivity/elasticity of the damping ratio to perturbations
damping <- function(matA) {  # define function for damping ratio
  eig <- eigen(matA)$values
  dm <- rle(Mod(eig))$values
  return(dm[1] / dm[2])
}

perturb_trans(matU, matF, demog_stat = "damping")
}
}
\author{
Rob Salguero-Gómez <rob.salguero@zoo.ox.ac.uk>

Patrick Barks <patrick.barks@gmail.com>
}
