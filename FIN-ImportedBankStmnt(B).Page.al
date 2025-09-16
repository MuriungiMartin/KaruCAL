#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69185 "FIN-Imported Bank Stmnt (B)"
{
    PageType = List;
    SourceTable = UnknownTable61830;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Transaction Code";"Transaction Code")
                {
                    ApplicationArea = Basic;
                }
                field(Account;Account)
                {
                    ApplicationArea = Basic;
                }
                field(Description1;Description1)
                {
                    ApplicationArea = Basic;
                }
                field(Description2;Description2)
                {
                    ApplicationArea = Basic;
                }
                field("Statement No";"Statement No")
                {
                    ApplicationArea = Basic;
                }
                field("Cheque No";"Cheque No")
                {
                    ApplicationArea = Basic;
                }
                field("More Chq Det";"More Chq Det")
                {
                    ApplicationArea = Basic;
                }
                field("Chq Code";"Chq Code")
                {
                    ApplicationArea = Basic;
                }
                field(Details;Details)
                {
                    ApplicationArea = Basic;
                }
                field("Branch Code";"Branch Code")
                {
                    ApplicationArea = Basic;
                }
                field("Branch Name";"Branch Name")
                {
                    ApplicationArea = Basic;
                }
                field("Our Ref";"Our Ref")
                {
                    ApplicationArea = Basic;
                }
                field("Tran Date";"Tran Date")
                {
                    ApplicationArea = Basic;
                }
                field("Value Date";"Value Date")
                {
                    ApplicationArea = Basic;
                }
                field(Currency;Currency)
                {
                    ApplicationArea = Basic;
                }
                field("Money In";"Money In")
                {
                    ApplicationArea = Basic;
                }
                field("Money Out";"Money Out")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Process Imported Records")
            {
                ApplicationArea = Basic;
                Image = PeriodEntries;

                trigger OnAction()
                begin

                       StatRec.Reset;
                       StatRec.SetRange(StatRec.Description1,'Cash Deposit');

                       if StatRec.Find('-') then begin
                       repeat
                       StudNo:='';
                       for i:=1 to 20 do begin
                       if Cust.Get(CopyStr(StatRec.Description2,1,i)) then
                       StudNo:=CopyStr(StatRec.Description2,1,i);
                       end;
                       if StudNo<>'' then begin
                       if not ImpRec.Get(StatRec."Transaction Code") then begin
                       ImpRec.Init;
                       ImpRec."Student No.":=StudNo;
                       ImpRec."Transaction Code":= StatRec."Transaction Code";
                       ImpRec.Date:=StatRec."Tran Date";
                       ImpRec.Description:=CopyStr(StatRec.Description2,1,35);
                       ImpRec.Amount:=StatRec."Money In";
                       ImpRec.Insert;
                       end;
                       end;
                       until StatRec.Next=0;
                       end;
                       Message('Completed Successfully');
                end;
            }
        }
    }

    var
        Cust: Record Customer;
        ImpRec: Record UnknownRecord61552;
        StatRec: Record UnknownRecord61830;
        i: Integer;
        StudNo: Code[20];
}

