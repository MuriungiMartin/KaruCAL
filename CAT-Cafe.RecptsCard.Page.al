#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69085 "CAT-Cafe. Recpts Card"
{
    PageType = Document;
    RefreshOnActivate = false;
    SourceTable = UnknownTable61783;
    SourceTableView = where(Status=filter(New));

    layout
    {
        area(content)
        {
            group(Receipts)
            {
                Caption = 'Please press enter for the system to generate a new receipt no.';
            }
            group(General)
            {
                Caption = 'Receipt Header';
                field("Receipt No.";"Receipt No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Transaction Type";"Transaction Type")
                {
                    ApplicationArea = Basic;
                    Editable = true;

                    trigger OnValidate()
                    begin
                         CurrPage.Update;
                    end;
                }
                field(Department;Department)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Department Name";"Department Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Receipt Date";"Receipt Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Cafeteria Section";"Cafeteria Section")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
            group(Details1)
            {
                Caption = 'Receipt Details';
                part(Details;"CAT-Cafe. Recpts Line")
                {
                    Caption = 'Meal Items';
                    SubPageLink = "Receipt No."=field("Receipt No.");
                }
            }
            group(Amounts)
            {
                Caption = 'Value of Receipts';
                field("Recept Total";"Recept Total")
                {
                    ApplicationArea = Basic;
                    Caption = 'Recept Total';
                    Editable = false;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 12;
                    Caption = 'Amount Paid';
                    Importance = Additional;
                    Style = StrongAccent;
                    StyleExpr = true;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Post_Print)
            {
                ApplicationArea = Basic;
                Caption = 'Post & Print';
                Image = Post;
                Promoted = true;
                ShortCutKey = 'F12';

                trigger OnAction()
                begin

                    if Sections='' then Error('Select the CAFE` Section first!');
                    receiptDet.Reset;
                    receiptDet.SetRange(receiptDet."Receipt No.","Receipt No.");
                    sums:=0;
                    if receiptDet.Find('-') then
                      begin
                      repeat
                      begin
                      sums:=sums+receiptDet."Total Amount";
                      if receiptDet."Meal Code"<>'' then begin
                        if receiptDet.Quantity<1 then
                          Error('Lines should not have ''ZERO'' QUANTITIES.');
                      end;
                        if receiptDet."Unit Price"=0 then
                          Error('There is a Line with 0, ''ZERO'' SELLING PRICE..');
                      end;
                      until receiptDet.Next=0;
                      end;

                      if "Transaction Type"="transaction type"::CREDIT then
                        if "Employee No"='' then Error('Employee Number for a Credit Purchase Must be Populated.');

                    if Amount<sums then
                      if "Transaction Type"="transaction type"::CASH then
                      Error('The Amount Paid can not be less than Bill Total!');

                    if sums=0.0 then
                      Error('There are no Items to Print!');

                    cafeReceipts.Reset;
                    cafeReceipts.SetRange(cafeReceipts."Receipt No.","Receipt No.");
                    if cafeReceipts.Find('-') then begin
                    Report.Run(51808,true,true,cafeReceipts);
                    end;

                    // Create Ledger Entries
                    receiptLine.Reset;
                    receiptLine.SetRange(receiptLine."Receipt No.","Receipt No.");
                    if receiptLine.Find('-') then begin
                    repeat
                    begin
                    MealInventory.Reset;
                    MealInventory.SetRange(MealInventory."Item No",receiptLine."Meal Code");
                    MealInventory.SetRange(MealInventory."Cafeteria Section",receiptLine."Cafeteria Section");
                    MealInventory.SetRange(MealInventory."Menu Date",receiptLine.Date);
                    if MealInventory.Find('-') then begin
                       MealInventory.CalcFields(MealInventory."Quantity in Store");
                       if MealInventory."Quantity in Store"<receiptLine.Quantity then
                        Error('ERROR: Less quantity on store!');
                    end;
                    mealJournEntries.Init;
                      mealJournEntries.Template:='CAFE_INVENTORY';
                      mealJournEntries.Batch:='ADJUSTMENT';
                      mealJournEntries."Meal Code":=receiptLine."Meal Code";
                      mealJournEntries."Posting Date":=receiptLine.Date;
                      mealJournEntries."Line No.":=receiptLine."Line No.";
                      mealJournEntries."Cafeteria Section":=receiptLine."Cafeteria Section";
                      mealJournEntries."Transaction Type":=mealJournEntries."transaction type"::"Negative Adjustment";
                      mealJournEntries.Quantity:=receiptLine.Quantity*(-1);
                      mealJournEntries."User Id":=receiptLine.User;
                      mealJournEntries."Unit Price":=receiptLine."Unit Price";
                      mealJournEntries."Line Amount":=receiptLine."Total Amount";
                      mealJournEntries."Meal Description":=receiptLine."Meal Descption";
                      mealJournEntries."Receipt No.":="Receipt No.";
                      if "Transaction Type"="transaction type"::CASH then
                      mealJournEntries."Sale Tyle":=mealJournEntries."sale tyle"::"Cash Sale"
                      else if  "Transaction Type"="transaction type"::CREDIT then
                      mealJournEntries."Sale Tyle":=mealJournEntries."sale tyle"::"Credit Sale"
                      else if  "Transaction Type"="transaction type"::"ADVANCE PAYMENT" then
                      mealJournEntries."Sale Tyle":=mealJournEntries."sale tyle"::"Advance Payment";
                    mealJournEntries.Insert;
                    end;
                    until receiptLine.Next = 0;
                      end;
                            Status:=Status::Printed;
                            "Cafeteria Section":="Cafeteria Section";
                            Modify;
                            Message('Printed Successfully!');
                            sums:=0.0;
                            CurrPage.Update;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Clear(IsGrpVisible);

         if "Transaction Type"="transaction type"::CASH then begin

          IsGrpVisible:=false;
          end else begin
          IsGrpVisible:=true;
         // CurrPage."Employee No".VISIBLE:=TRUE;
         // CurrPage."Employee Name".VISIBLE:=TRUE;
         // CurrPage.lblAmount.EDITABLE:=FALSE;
          end;


        //currpage.EmployeeDet visible=IsGrpVisible;
    end;

    var
        [InDataSet]
        IsGrpVisible: Boolean;
        "User Setup": Record "User Setup";
        cafeReceipts: Record UnknownRecord61783;
        receiptDet: Record UnknownRecord61775;
        sums: Decimal;
        sections: Code[10];
        mealJournEntries: Record UnknownRecord61788;
        receiptLine: Record UnknownRecord61775;
        MealInventory: Record UnknownRecord61782;
}

