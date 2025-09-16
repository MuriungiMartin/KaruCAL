#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69108 "HRM-Import Emp. Trans Buff"
{
    PageType = List;
    SourceTable = UnknownTable61829;

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
                field("Employee No";"Employee No")
                {
                    ApplicationArea = Basic;
                }
                field(Period;Period)
                {
                    ApplicationArea = Basic;
                }
                field(Amount;Amount)
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
            action(imp)
            {
                ApplicationArea = Basic;
                Caption = 'Import transactons';
                Image = ImportExcel;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if Confirm('Import?',false)= false then Error('Cancelled by user!');
                    Xmlport.Run(50222,false,true);
                end;
            }
            action(pos)
            {
                ApplicationArea = Basic;
                Caption = 'post transactions';
                Image = PostBatch;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if Confirm('Update Transactions?',false)=false then Error('Cancelled by user!');
                    if Confirm('These will update the transactions for all employees on this page, continue?',false)=false then Error('Cancelled by '+UserId);
                    rectrans.Reset;
                    if rectrans.Find('-') then begin
                    repeat
                    begin
                      premptrans.Reset;
                      premptrans.SetRange(premptrans."Employee Code",rectrans."Employee No");
                      premptrans.SetRange(premptrans."Transaction Code",rectrans."Transaction Code");
                      premptrans.SetRange(premptrans."Payroll Period",rectrans.Period);
                      if premptrans.Find('-') then begin
                        premptrans.Amount:=rectrans.Amount;
                        premptrans.Modify;
                      end else begin
                      premptrans.Init;
                      premptrans."Employee Code":=rectrans."Employee No";
                      premptrans."Transaction Code":=rectrans."Transaction Code";
                      premptrans."Period Month":=Date2dmy(rectrans.Period,2);
                      premptrans."Period Year":=Date2dmy(rectrans.Period,3);
                      premptrans."Payroll Period":=rectrans.Period;
                      premptrans.Amount:=rectrans.Amount;
                      premptrans.Insert(true);
                      end;
                      rectrans.Delete(true);
                    end;
                    until rectrans.Next=0;
                    end else Error('There are no records to update');
                end;
            }
        }
    }

    var
        rectrans: Record UnknownRecord61829;
        premptrans: Record UnknownRecord61091;
}

