---
title: AADSC.recommendations.Microsoft.Identity.IAM.Insights.UserRiskPolicy
description: Microsoft.Identity.IAM.Insights.UserRiskPolicy - Protect all users with a user risk policy
---

# Protect all users with a user risk policy



| | |
|-|-|
| **Name** | Microsoft.Identity.IAM.Insights.UserRiskPolicy |
| **Control** | Azure AD Recommendations |
| **Description** | Azure Active Directory (Azure AD) recommendations are personalized and actionable insights for you to implement Azure AD best practices in your tenant. The Azure AD recommendation service runs daily to check your tenant against predefined conditions for every recommendation. If the service detects that a recommendation applies to your tenant, the corresponding recommendation object is generated and its status is set to active. |
| **Severity** |  |

## How to fix
| | |
|-|-|
| **Recommendation** |  |
| **Configuration** | directory/recommendations |
| **Setting** | `status` |
| **Recommended Value** | 'completedBySystem' |
| **Default Value** |  |
| **Graph API Docs** | [List impactedResources - Microsoft Graph beta - Microsoft Learn](https://learn.microsoft.com/en-us/graph/api/recommendation-list-impactedresources) |
| **Graph Explorer** | [View in Graph Explorer](https://developer.microsoft.com/en-us/graph/graph-explorer?request=directory/recommendations&method=GET&version=beta&GraphUrl=https://graph.microsoft.com) |


