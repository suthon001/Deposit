/// <summary>
/// Unknown DepositPermiss (ID 70500).
/// </summary>
permissionset 70500 DepositPermiss
{
    Assignable = true;
    Caption = 'DepositPermiss', MaxLength = 30;
    Permissions =
        table "TPP Deposit Entry" = X,
        tabledata "TPP Deposit Entry" = RMID,
        codeunit "TPP PreviewPosting Deposit" = X,
        codeunit "TPP Deposit Func" = X,
        page "TPP Deposit Entry" = X,
        page "TPP Get Deposit Entry" = X,
        page "TPP Show Deposit Entry" = X;
}
