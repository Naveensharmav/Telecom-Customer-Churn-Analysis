# Power BI Measures: Telco Customer Churn Analysis

All measures sit in the `Measures Table`. Measures that count customers use `telco_customer_churn`, and risk measures use the `v_churn_risk_updated` view (active customers only). `Churn(Binary)` is 1 for churned customers and 0 for retained.

41 measures. The formulas are listed below the table.

| # | Measure | Description |
|---|---|---|
| 1 | Total Customers | Distinct customers in the customer table. Responds to slicers and page filters. |
| 2 | Retained Customers | Distinct active (not churned) customers, counted from the risk view. |
| 3 | Churn % | Churned customers divided by total customers. |
| 4 | Retained % | Retained customers divided by total customers. |
| 5 | Monthly Revenue Lost | Monthly charges of customers who churned. |
| 6 | High Risk Active Count | Active customers labelled High Risk. |
| 7 | High-Risk Monthly Revenue | Monthly charges of active customers labelled High Risk. |
| 8 | Total Revenue Lost | Lifetime billing (TotalCharges) of customers who churned. |
| 9 | Month-to-month customers | Customers on a month-to-month contract. |
| 10 | Churned Customers | Customers who left (Churn = Yes). |
| 11 | % Concentration | Retained customers in the current selection as a share of all customers in the risk view, ignoring filters. Shows how big a selected risk band is. |
| 12 | Active Revenue at Risk | Monthly charges of active customers in the risk view, within the current selection. |
| 13 | Avg Monthly Charge (Retained) | Average monthly charge of retained customers. |
| 14 | Annualised Revenue Lost | Monthly Revenue Lost multiplied by 12. |
| 15 | Annualised High Risk Revenue | High-Risk Monthly Revenue multiplied by 12. |
| 16 | Avg Lifetime Billing (Churned) | Average total billing (TotalCharges) of churned customers. |
| 17 | Avg Lifetime Billing (Retained) | Average total billing (TotalCharges) of retained customers. |
| 18 | Avg Monthly Charge (Churned) | Average monthly charge of churned customers. |
| 19 | Avg Tenure (Churned) | Average tenure in months of churned customers. |
| 20 | Avg Tenure (Retained) | Average tenure in months of retained customers. |
| 21 | Callout - Pricing | Full text callout comparing what churned and retained customers pay and how long they stay. Uses blank-safe wording when a selection has no churned or retained customers. |
| 22 | Callout - Revenue Concentration | Full text callout on how much of the revenue lost came from month-to-month customers, and Fiber optic's share of revenue against its share of revenue lost. |
| 23 | PR Churned Pay | Pricing callout piece: average monthly charge of churned customers, formatted as text. |
| 24 | PR Pay Difference | Pricing callout piece: percentage difference between churned and retained monthly charge, with 'more' or 'less'. |
| 25 | PR Retained Pay | Pricing callout piece: average monthly charge of retained customers, formatted as text. |
| 26 | PR Churned Tenure | Pricing callout piece: average churned tenure, formatted as months. |
| 27 | PR Retained Tenure | Pricing callout piece: average retained tenure, formatted as text. |
| 28 | PR Billing Word | Pricing callout piece: 'higher-billing' or 'lower-billing', depending on which group pays more. |
| 29 | PR Closing Tail | Pricing callout piece: closing words that change with the pay comparison. |
| 30 | RC M2M Lost | Revenue callout piece: monthly revenue lost from month-to-month customers. |
| 31 | RC Fiber Lost | Revenue callout piece: monthly revenue lost from Fiber optic customers. |
| 32 | RC Fiber MRR | Revenue callout piece: total monthly charges of Fiber optic customers. |
| 33 | RC M2M Lost Text | Revenue callout piece: month-to-month revenue lost, formatted in thousands. |
| 34 | RC Total Lost Text | Revenue callout piece: total monthly revenue lost, formatted in thousands. |
| 35 | RC M2M Share Text | Revenue callout piece: month-to-month share of the revenue lost, as a percentage. |
| 36 | RC Fiber MRR Share Text | Revenue callout piece: Fiber optic share of total monthly revenue, as a percentage. |
| 37 | RC Fiber Lost Share Text | Revenue callout piece: Fiber optic share of the revenue lost, as a percentage. |
| 38 | Service Adoption % | Share of internet customers who use the add-on service selected in the Services table. The related chart was dropped from the final dashboard. |
| 39 | Sub - High Risk Share | Card subtitle: High Risk customers as a share of active customers. |
| 40 | Sub - High Risk MRR Share | Card subtitle: High Risk monthly revenue as a share of active monthly revenue. |
| 41 | Heatmap Cell | Text for each heatmap cell: churn % and customer count on two lines. |

## Formulas

### Total Customers

```dax
DISTINCTCOUNT(
    telco_customer_churn[customerID]
)
```

### Retained Customers

```dax
DISTINCTCOUNT(
    v_churn_risk_updated[customerID]
)
```

### Churn %

```dax
DIVIDE(
    [Churned Customers],
    [Total Customers]
)
```

### Retained %

```dax
DIVIDE(
    [Retained Customers],
    [Total Customers]
)
```

### Monthly Revenue Lost

```dax
CALCULATE(
    SUM(
        telco_customer_churn[MonthlyCharges]
    ),
    telco_customer_churn[Churn(Binary)] = 1
)
```

### High Risk Active Count

```dax
CALCULATE(
    [Total Customers],
    v_churn_risk_updated[Risk_profiles] = "High Risk"
    )
```

### High-Risk Monthly Revenue

```dax
CALCULATE(
    SUM(
        v_churn_risk_updated[MonthlyCharges]
    ),
    v_churn_risk_updated[Risk_profiles] = "High Risk"
)
```

### Total Revenue Lost

```dax
CALCULATE(
    SUM(
        telco_customer_churn[TotalCharges]
    ),
    telco_customer_churn[Churn(Binary)] = 1
)
```

### Month-to-month customers

```dax
CALCULATE(
    [Total Customers],
    telco_customer_churn[Contract] = "Month-to-month"
)
```

### Churned Customers

```dax
CALCULATE(
    [Total Customers],
    telco_customer_churn[Churn(Binary)] = 1
)
```

### % Concentration

```dax
DIVIDE(
    [Retained Customers],
    CALCULATE(
        COUNTROWS(v_churn_risk_updated),
        ALL(
            v_churn_risk_updated
        )
    )
)
```

### Active Revenue at Risk

```dax
SUM(
    v_churn_risk_updated[MonthlyCharges]
)
```

### Avg Monthly Charge (Retained)

```dax
CALCULATE(AVERAGE(telco_customer_churn[MonthlyCharges]), telco_customer_churn[Churn(Binary)] = 0)
```

### Annualised Revenue Lost

```dax
[Monthly Revenue Lost] * 12
```

### Annualised High Risk Revenue

```dax
[High-Risk Monthly Revenue] * 12
```

### Avg Lifetime Billing (Churned)

```dax
CALCULATE(AVERAGE(telco_customer_churn[TotalCharges]), telco_customer_churn[Churn(Binary)] = 1)
```

### Avg Lifetime Billing (Retained)

```dax
CALCULATE(AVERAGE(telco_customer_churn[TotalCharges]), telco_customer_churn[Churn(Binary)] = 0)
```

### Avg Monthly Charge (Churned)

```dax
CALCULATE(AVERAGE(telco_customer_churn[MonthlyCharges]), telco_customer_churn[Churn(Binary)] = 1)
```

### Avg Tenure (Churned)

```dax
CALCULATE(AVERAGE(telco_customer_churn[tenure]), telco_customer_churn[Churn(Binary)] = 1)
```

### Avg Tenure (Retained)

```dax
CALCULATE(AVERAGE(telco_customer_churn[tenure]), telco_customer_churn[Churn(Binary)] = 0)
```

### Callout - Pricing

```dax
VAR ChurnPay = [Avg Monthly Charge (Churned)]
VAR RetPay   = [Avg Monthly Charge (Retained)]
VAR Diff     = DIVIDE(ChurnPay - RetPay, RetPay)
RETURN
IF(
    ISBLANK(ChurnPay) || ISBLANK(RetPay),
    "Not enough churned and retained customers in the current selection",
    "Churned customers pay " & FORMAT(ChurnPay, "$0.00") & "/mo on average, " &
    FORMAT(ABS(Diff), "0.0%") & IF(Diff >= 0, " more", " less") &
    " than retained customers (" & FORMAT(RetPay, "$0.00") & "), and left after " &
    FORMAT([Avg Tenure (Churned)], "0") & " months against " &
    FORMAT([Avg Tenure (Retained)], "0") & " for those who stay." &
    IF(Diff > 0, " The company is losing its higher-billing customers, not its cheapest.", "")
)
```

### Callout - Revenue Concentration

```dax
VAR Lost    = [Monthly Revenue Lost]
VAR M2M     = CALCULATE([Monthly Revenue Lost],
                  KEEPFILTERS(telco_customer_churn[Contract] = "Month-to-month"))
VAR FiberLost = CALCULATE([Monthly Revenue Lost],
                  KEEPFILTERS(telco_customer_churn[InternetService] = "Fiber optic"))
VAR FiberMRR  = CALCULATE(SUM(telco_customer_churn[MonthlyCharges]),
                  KEEPFILTERS(telco_customer_churn[InternetService] = "Fiber optic"))
VAR AllMRR    = SUM(telco_customer_churn[MonthlyCharges])
RETURN
IF(
    Lost = 0 || ISBLANK(Lost),
    "No revenue lost in the current selection",
    FORMAT(M2M / 1000, "$#,##0.0") & "K of the " & FORMAT(Lost / 1000, "$#,##0.0") &
    "K monthly revenue lost (" & FORMAT(DIVIDE(M2M, Lost), "0.0%") &
    ") came from month-to-month customers. Fiber optic holds " &
    FORMAT(DIVIDE(FiberMRR, AllMRR), "0.0%") & " of monthly revenue but accounts for " &
    FORMAT(DIVIDE(FiberLost, Lost), "0.0%") & " of the revenue lost."
)
```

### PR Churned Pay

```dax
FORMAT([Avg Monthly Charge (Churned)], "$0.00")
```

### PR Pay Difference

```dax
VAR Diff = DIVIDE([Avg Monthly Charge (Churned)] - [Avg Monthly Charge (Retained)], [Avg Monthly Charge (Retained)])
RETURN FORMAT(ABS(Diff), "0.0%") & IF(Diff >= 0, " more", " less")
```

### PR Retained Pay

```dax
FORMAT([Avg Monthly Charge (Retained)], "$0.00")
```

### PR Churned Tenure

```dax
FORMAT([Avg Tenure (Churned)], "0") & " months"
```

### PR Retained Tenure

```dax
FORMAT([Avg Tenure (Retained)], "0")
```

### PR Billing Word

```dax
IF([Avg Monthly Charge (Churned)] > [Avg Monthly Charge (Retained)], "higher-billing", "lower-billing")
```

### PR Closing Tail

```dax
IF([Avg Monthly Charge (Churned)] > [Avg Monthly Charge (Retained)], ", not its cheapest.", ".")
```

### RC M2M Lost

```dax
CALCULATE([Monthly Revenue Lost], KEEPFILTERS(telco_customer_churn[Contract] = "Month-to-month"))
```

### RC Fiber Lost

```dax
CALCULATE([Monthly Revenue Lost], KEEPFILTERS(telco_customer_churn[InternetService] = "Fiber optic"))
```

### RC Fiber MRR

```dax
CALCULATE(SUM(telco_customer_churn[MonthlyCharges]), KEEPFILTERS(telco_customer_churn[InternetService] = "Fiber optic"))
```

### RC M2M Lost Text

```dax
FORMAT([RC M2M Lost] / 1000, "$#,##0.0") & "K"
```

### RC Total Lost Text

```dax
FORMAT([Monthly Revenue Lost] / 1000, "$#,##0.0") & "K"
```

### RC M2M Share Text

```dax
FORMAT(DIVIDE([RC M2M Lost], [Monthly Revenue Lost]), "0.0%")
```

### RC Fiber MRR Share Text

```dax
FORMAT(DIVIDE([RC Fiber MRR], SUM(telco_customer_churn[MonthlyCharges])), "0.0%")
```

### RC Fiber Lost Share Text

```dax
FORMAT(DIVIDE([RC Fiber Lost], [Monthly Revenue Lost]), "0.0%")
```

### Service Adoption %

```dax
VAR svc = SELECTEDVALUE(Services[Service])
VAR Base =
CALCULATE(
    [Total Customers],
    telco_customer_churn[InternetService] <> "No"
)
VAR Adopted = 
    SWITCH(
        svc,
        "Online Backup", CALCULATE(
            [Total Customers], 
            telco_customer_churn[InternetService] <> "No",
            telco_customer_churn[OnlineBackup] = "Yes"),
        "Device Protection", CALCULATE(
            [Total Customers], 
            telco_customer_churn[InternetService] <> "No",
            telco_customer_churn[DeviceProtection] = "Yes"),
        "Tech Support", CALCULATE(
            [Total Customers], 
            telco_customer_churn[InternetService] <> "No",
            telco_customer_churn[TechSupport] = "Yes"),
        "Online Security", CALCULATE(
            [Total Customers], 
            telco_customer_churn[InternetService] <> "No",
            telco_customer_churn[OnlineSecurity] = "Yes")
    )
RETURN DIVIDE(
    Adopted,
    Base
)
```

### Sub - High Risk Share

```dax
FORMAT(DIVIDE([High Risk Active Count], [Retained Customers]), "0.0%") & " of active customers"
```

### Sub - High Risk MRR Share

```dax
FORMAT(DIVIDE([High-Risk Monthly Revenue], [Active Revenue at Risk]), "0.0%") & " of active monthly revenue"
```

### Heatmap Cell

```dax
IF(
    ISBLANK([Churn %]),
    BLANK(),
    FORMAT([Churn %], "0.0%") & UNICHAR(10) & FORMAT([Total Customers], "#,##0")
)
```
