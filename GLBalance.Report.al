#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51643 "G/L Balance"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/GL Balance.rdlc';

    dataset
    {
        dataitem("G/L Account";"G/L Account")
        {
            DataItemTableView = sorting("No.") where("No."=const('33001'));
            RequestFilterFields = "Global Dimension 2 Filter";
            column(ReportForNavId_6710; 6710)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(USERID;UserId)
            {
            }
            column(G_L_Account__No__;"No.")
            {
            }
            column(G_L_Account_Name;Name)
            {
            }
            column(G_L_Account_Balance;Balance)
            {
            }
            column(AccBalance;AccBalance)
            {
            }
            column(G_L_AccountCaption;G_L_AccountCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(G_L_Account__No__Caption;FieldCaption("No."))
            {
            }
            column(G_L_Account_NameCaption;FieldCaption(Name))
            {
            }
            column(G_L_Account_BalanceCaption;FieldCaption(Balance))
            {
            }

            trigger OnAfterGetRecord()
            begin
                GLEntry.Reset;
                GLEntry.SetRange(GLEntry."G/L Account No.",'33001');
                //GLEntry.SETRANGE(GLEntry.Description,'Payment Distribution');
                GLEntry.SetRange(GLEntry."Global Dimension 2 Code",'BCOM');
                //GLEntry.SETRANGE(GLEntry."Document No.",'T0*');
                if GLEntry.Find('-') then begin
                repeat
                mySt:=CopyStr(GLEntry.Description,1,7);

                if CopyStr(GLEntry."Document No.",1,2) = 'T0' then begin
                if CopyStr(GLEntry.Description,1,8) = 'Fees for' then begin
                AccBalance:=AccBalance+GLEntry.Amount;
                if StudCharges.Get(GLEntry."Document No.") = false then
                Error('%1',GLEntry."Document No.");

                end;
                end;

                until GLEntry.Next = 0;

                end
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        GLEntry: Record "G/L Entry";
        AccBalance: Decimal;
        mySt: Text[30];
        StudCharges: Record UnknownRecord61535;
        G_L_AccountCaptionLbl: label 'G/L Account';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

