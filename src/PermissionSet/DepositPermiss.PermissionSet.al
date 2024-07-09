/// <summary>
/// Unknown TPP DepositPermission (ID 70500).
/// </summary>
permissionset 70500 "TPP DepositPermiss"
{
    Assignable = true;
    Caption = 'Deposit Permission';
    Permissions =
        table "TPP Deposit Entry" = X,
        tabledata "TPP Deposit Entry" = RMID;

}
