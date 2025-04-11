' MODEL LP2 for Eviews version 6
' from Wynne Godley & Marc Lavoie
' MONETARY ECONOMICS
' Chapter 5

' This program creates model LP2, described in section 5.8, and simulates the model
' to produce results in figures 5.5 - 5.9


' ****************************************************************************
' Copyright (c) 2006 Gennaro Zezza
' Permission is hereby granted, free of charge, to any person obtaining a 
' copy of this software and associated documentation files (the "Software"),
' to deal in the Software without restriction, including without limitation
' the rights to use, copy, modify, merge, publish, distribute, sublicense, 
' and/or sell copies of the Software, and to permit persons to whom the 
' Software is furnished to do so, subject to the following conditions:
' 
' The above copyright notice and this permission notice shall be included in 
' all copies or substantial portions of the Software.
' 
' THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
' IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
' FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
' AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
' LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING 
' FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS 
' IN THE SOFTWARE.
' ****************************************************************************

' Create a workfile, naming it LP2, to hold annual data from 1945 to 2010

wfcreate(wf=lp2, page=annual) a 1945 2010

' Creates and documents series
series add
add.displayname Random shock to expectations
series b_cb
b_cb.displayname Government bills held by Central Bank
series b_d
b_d.displayname Demand for government bills
series b_h
b_h.displayname Government bills held by households
series b_s
b_s.displayname Government bills supplied by government
series bl_d
bl_d.displayname Demand for government bonds
series bl_h
bl_h.displayname Government bonds held by households
series bl_s
bl_s.displayname Supply for government bonds
series cg
cg.displayname Capital gains on bonds
series cg_e
cg_e.displayname Expected capital gains on bonds
series cons
cons.displayname Consumption goods
series er_rbl
er_rbl.displayname Expected rate of return on bonds
series g
g.displayname Government goods
series h_d
h_d.displayname Demand for cash
series h_h
h_h.displayname Cash money held by households
series h_s
h_s.displayname Cash money supplied by central bank
series p_bl
p_bl.displayname Price of bonds
series p_bl_e
p_bl_e.displayname Expected price of bonds
series p_bl_bar
p_bl_bar.displayname Exogenously set price of bonds
series r_b
r_b.displayname Interest rate on government bills
series r_bar
r_bar.displayname Exogenously set interest rate on government bills
series r_bl
r_bl.displayname Interest rate on government bonds
series t
t.displayname Taxes
series tp
tp.displayname Target proportion in households portfolio
series v
v.displayname Households wealth
series v_e
v_e.displayname Expected households wealth
series y
y.displayname Income = GDP
series yd_r
yd_r.displayname Regular disposable income of households
series yd_r_e
yd_r_e.displayname Expected regular disposable income of households

' Generate parameters
series alpha1
alpha1.displayname Propensity to consume out of income
series alpha2
alpha2.displayname Propensity to consume out of wealth
series beta
beta.displayname Adjustment parameter in price of bills
series betae
betae.displayname Adjustment parameter in expectations
series bot
bot.displayname Bottom value for TP
series chi
chi.displayname Weight of conviction in expected bond price
series lambda10
lambda10.displayname Parameter in asset demand function
series lambda12
lambda12.displayname Parameter in asset demand function
series lambda13
lambda13.displayname Parameter in asset demand function
series lambda14
lambda14.displayname Parameter in asset demand function
series lambda20
lambda20.displayname Parameter in asset demand function
series lambda22
lambda22.displayname Parameter in asset demand function
series lambda23
lambda23.displayname Parameter in asset demand function
series lambda24
lambda24.displayname Parameter in asset demand function
series lambda30
lambda30.displayname Parameter in asset demand function
series lambda32
lambda32.displayname Parameter in asset demand function
series lambda33
lambda33.displayname Parameter in asset demand function
series lambda34
lambda34.displayname Parameter in asset demand function
series theta
theta.displayname Tax rate
series top
top.displayname Top value for TP
series z1
z1.displayname Switch parameter
series z2
z2.displayname Switch parameter

' Set sample size to all workfile range
smpl @all

' Assign values for
'   PARAMETERS
alpha1=0.8
alpha2=0.2
beta=0.01
betae=0.5
chi=0.1
lambda20 = 0.44196
lambda22 = 1.1
lambda23 = 1
lambda24 = 0.03
lambda30 = 0.3997
lambda32 = 1
lambda33 = 1.1
lambda34 = 0.03
theta=0.1938
bot=0.495
top=0.505
z1=0
z2=0
'   EXOGENOUS
g=20
r_bar = 0.12
p_bl_bar = 11.1111111
'   Opening values for stocks
v = 95.803
b_h = 37.839
b_s = 57.964
b_cb = b_s - b_h
bl_h = 1.892
bl_s = bl_h
h_s = 20.125
' Opening values for lagged endogenous
yd_r = 95.803
r_b = r_bar
p_bl = p_bl_bar
p_bl_e = p_bl
tp=bl_h*p_bl/(bl_h*p_bl+b_h)
z1=0+1*(tp>top)
z2=0+1*(tp<bot)
' Random shocks
add = 0
' ****************************************************************************

' Create a model object, and name it lp2_mod

model lp2_mod

' Add equations to model LP2

' Determination of output - eq. 5.1
lp2_mod.append y = cons + g

' Regular disposable income - eq. 5.2
lp2_mod.append yd_r = y - t + r_b(-1)*b_h(-1) + bl_h(-1)

' Tax payments - eq. 5.3
lp2_mod.append t = theta*(y + r_b(-1)*b_h(-1) + bl_h(-1))

' Wealth accumulation - eq. 5.4
lp2_mod.append v = v(-1) + (yd_r - cons) + cg

' Capital gains on bonds - eq. 5.5
lp2_mod.append cg = (p_bl-p_bl(-1))*bl_h(-1)

' Consumption function - eq. 5.6
lp2_mod.append cons = alpha1*yd_r_e + alpha2*v(-1)

' Expected wealth - eq. 5.7
lp2_mod.append v_e = v(-1) + (yd_r_e - cons) + cg

' Cash money - eq. 5.8
lp2_mod.append h_h = v - b_h - p_bl*bl_h

' Demand for cash - eq. 5.9
lp2_mod.append h_d = v_e - b_d - p_bl*bl_d

' Demand for government bills - eq. 5.10
lp2_mod.append b_d = v_e*(lambda20 + lambda22*r_b - lambda23*er_rbl - lambda24*(yd_r_e/v_e))

' Demand for government bonds - eq. 5.11
lp2_mod.append bl_d = v_e*(lambda30 - lambda32*r_b + lambda33*er_rbl - lambda34*(yd_r_e/v_e))/p_bl

' Bills held by households - eq. 5.12
lp2_mod.append b_h = b_d

' Bonds held by households - eq. 5.13
lp2_mod.append bl_h = bl_d

' Supply of government bills - eq. 5.14
lp2_mod.append b_s = b_s(-1) + (g + r_b(-1)*b_s(-1) + bl_s(-1)) - (t + r_b(-1)*b_cb(-1)) -p_bl*(bl_s-bl_s(-1))

' Supply of cash - eq. 5.15
lp2_mod.append h_s = h_s(-1) + b_cb - b_cb(-1)

' Government bills held by the central bank - eq. 5.16
lp2_mod.append b_cb = b_s - b_h

' Supply of government bonds - eq. 5.17
lp2_mod.append bl_s = bl_h

' Expected rate of return on bonds - eq. 5.18
lp2_mod.append er_rbl = r_bl+chi*(p_bl_e - p_bl)/p_bl

' Interest rate on bonds - eq. 5.19
lp2_mod.append r_bl = 1/p_bl

' Expected price of bonds - eq. 5.20b
lp2_mod.append p_bl_e = p_bl_e(-1) -betae*(p_bl_e(-1) - p_bl) + add

' Expected capital gains - eq. 5.21
lp2_mod.append cg_e = chi*(p_bl_e - p_bl)*bl_h

' Expected regular disposable income - eq. 5.22
lp2_mod.append yd_r_e = yd_r(-1)

' Interest rate on bills - eq. 5.23
lp2_mod.append r_b = r_bar

' Price of bonds - eq. 5.24A
lp2_mod.append p_bl = (1 + z1*beta - z2*beta)*p_bl(-1)

' First switch - eq.5.25
lp2_mod.append z1 = 0 + 1*(tp > top)

' Second switch - eq.5.26
lp2_mod.append z2 = 0 + 1*(tp < bot)

' Target proportion of bills - eq.5.27
lp2_mod.append tp = (bl_h(-1)*p_bl(-1))/(bl_h(-1)*p_bl(-1) + b_h(-1))

' End of model

' Select the baseline scenario

lp2_mod.scenario baseline

' Drop first observation to get starting values for solving the model
smpl 1946 @last

' Solve the model for the current sample

lp2_mod.solve(i=p)

