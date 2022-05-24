/// <summary>
/// Unknown DSVC DepositPermission (ID 70500).
/// </summary>
permissionset 70500 "DSVC DepositPermiss"
{
    Assignable = true;
    Caption = 'Deposit Permission';
    Permissions =
        table "DSVC Deposit Entry" = X,
        tabledata "DSVC Deposit Entry" = RMID;

}
