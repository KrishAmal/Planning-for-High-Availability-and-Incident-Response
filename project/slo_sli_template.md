# API Service

| Category     | SLI | SLO                                                                                                         |
|--------------|-----|-------------------------------------------------------------------------------------------------------------|
| Availability |  no. of successful requests / Total no. of requests  | 99%                                                                                                         |
| Latency      |   Buckets of requests in a histogram showing 90% percentile  | 90% of requests below 100ms                                                                                 |
| Error Budget |  Percentage of remaining error budget   | Error budget is defined at 20%. This means that 20% of the requests can fail and still be within the budget |
| Throughput   |  Total no. of successful requests over a time period | 5 RPS indicates the application is functioning                                                              |
