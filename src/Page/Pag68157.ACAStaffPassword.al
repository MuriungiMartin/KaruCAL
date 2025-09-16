#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68157 "ACA-Staff Password"
{
    Caption = 'Staff Password';
    PageType = StandardDialog;
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            field(StudentNo;StudentNo)
            {
                ApplicationArea = Basic;
                Caption = 'Staff No.';
            }
            field(Password;Password)
            {
                ApplicationArea = Basic;
                Caption = 'Password';
                ExtendedDatatype = Masked;

                trigger OnValidate()
                begin
                    //IF SetPassword <> ConfirmPassword THEN
                    //  ERROR(Text001);
                    //IF NOT IdentityManagement.ValidatePasswordStrength(Password) THEN
                    //  ERROR(Text002);
                end;
            }
        }
    }

    actions
    {
    }

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        if CloseAction = Action::OK then begin
        HrEmp.Reset;
        HrEmp.SetRange(HrEmp."No.",StudentNo);
        if HrEmp.Find('-') then begin
         if HrEmp.Password=Password then
         Page.Run(39005633,HrEmp)
         else
         Error('Invalid Password ');
        end else begin
        Error('Invalid Staff Number');
        end;
        end
    end;

    var
        Text001: label 'The passwords that you entered did not match.';
        Text002: label 'The password that you entered does not meet the minimum requirements. It must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter, and one number.';
        IdentityManagement: Codeunit "Identity Management";
        [InDataSet]
        Password: Text[250];
        [InDataSet]
        ConfirmPassword: Text[250];
        Cust: Record Customer;
        StudentNo: Code[20];
        HrEmp: Record UnknownRecord61188;
        StaffNo: Code[20];
}

