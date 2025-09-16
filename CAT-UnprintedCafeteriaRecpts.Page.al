#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69090 "CAT-Unprinted Cafeteria Recpts"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = UnknownTable61783;
    SourceTableView = where(Status=filter(New));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Select;Select)
                {
                    ApplicationArea = Basic;
                }
                field("Receipt No.";"Receipt No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Receipt Date";"Receipt Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Transaction Type";"Transaction Type")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Recept Total";"Recept Total")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Cancel Reason";"Cancel Reason")
                {
                    ApplicationArea = Basic;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(User;User)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("Activity/Functions")
            {
                Caption = 'Activity/Functions';
                action(Mark_as_Printed)
                {
                    ApplicationArea = Basic;
                    Caption = 'Mark as Printed';

                    trigger OnAction()
                    begin

                        Receipts.Reset;
                        Receipts.SetRange(Receipts.Status,Receipts.Status::New);
                        Receipts.SetRange(Receipts.Select,true);

                        if not Receipts.Find('-') then
                          Error('No lines Selected!');

                        if Confirm('Mark as Printed?',true)=true then
                        begin
                        if Receipts.Find('-') then
                          begin
                            repeat
                              begin
                                Receipts.Status:=Receipts.Status::Printed;
                                Receipts.Select:=false;
                                Receipts.Modify;
                              end;
                              until Receipts.Next=0;
                          end;
                        end;
                        CurrPage.Update;
                    end;
                }
                action(Cancel_Selected)
                {
                    ApplicationArea = Basic;
                    Caption = 'Cancel Selected';

                    trigger OnAction()
                    begin

                        Receipts.Reset;
                        Receipts.SetRange(Receipts.Status,Receipts.Status::New);
                        Receipts.SetRange(Receipts.Select,true);

                        if not Receipts.Find('-') then
                          Error('No lines Selected!');

                        if Confirm('Cancel Selected?',true)=true then
                        begin
                        if Receipts.Find('-') then
                          begin
                            repeat
                              begin
                              if Receipts."Cancel Reason"='' then Error('Provide the Cancel Reason for all Cancelled Receipts.');
                                Receipts.Status:=Receipts.Status::Canceled;
                                Receipts.Select:=false;
                                Receipts.Modify;
                                receiptLines.Reset;
                                receiptLines.SetRange(receiptLines."Receipt No.",Receipts."Receipt No.");
                                if receiptLines.Find('-') then begin
                                  repeat
                                    begin
                        mealJournEntries.Reset;
                        mealJournEntries.SetRange(mealJournEntries."Meal Code",receiptLines."Meal Code");
                        mealJournEntries.SetRange(mealJournEntries."Receipt No.",Receipts."Receipt No.");
                        if mealJournEntries.Find('-') then begin
                        mealJournEntries.Delete;
                        end;
                        //  mealJournEntries.Template:='CAFE_INVENTORY';
                        //  mealJournEntries.Batch:='ADJUSTMENT';
                        //  mealJournEntries."Meal Code":=receiptLines."Meal Code";
                        //  mealJournEntries."Posting Date":=receiptLines.Date;
                        //  mealJournEntries."Line No.":=receiptLines."Line No.";
                        //  mealJournEntries."Cafeteria Section":=receiptLines."Cafeteria Section";
                        //  mealJournEntries."Transaction Type":=mealJournEntries."Transaction Type"::"Positive Adjustment";
                        //  mealJournEntries.Quantity:=receiptLines.Quantity;
                        //  mealJournEntries."User Id":=receiptLines.User;
                        //  mealJournEntries."Unit Price":=receiptLines."Unit Price";
                        //  mealJournEntries."Line Amount":=receiptLines."Total Amount";
                        //  mealJournEntries."Meal Description":=receiptLines."Meal Descption";
                        //  mealJournEntries.Source:=mealJournEntries.Source::Cancellation;
                        //mealJournEntries.INSERT;
                                    end;
                                  until receiptLines.Next=0;
                                end;

                              end;
                              until Receipts.Next=0;
                          end;
                        end;
                        CurrPage.Update;
                    end;
                }
            }
        }
    }

    var
        Receipts: Record UnknownRecord61783;
        mealJournEntries: Record UnknownRecord61788;
        receiptLines: Record UnknownRecord61775;
}

