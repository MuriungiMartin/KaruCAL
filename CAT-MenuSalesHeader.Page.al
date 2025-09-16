#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68301 "CAT-Menu Sales Header"
{
    PageType = Document;
    SourceTable = UnknownTable61170;
    SourceTableView = where(Posted=const(No));

    layout
    {
        area(content)
        {
            group(Control1)
            {
                field("Receipt No";"Receipt No")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field(Date;Date)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Customer Type";"Customer Type")
                {
                    ApplicationArea = Basic;
                    Editable = false;

                    trigger OnValidate()
                    begin
                          if ("Customer Type"="customer type"::Staff) or ("Customer Type"="customer type"::Department) then
                             begin
                                "Paid AmountEditable" :=false;
                                BalanceEditable :=false;
                             end
                           else begin
                                "Paid AmountEditable" :=true;
                               // CurrForm.Balance.editable:=true;
                           end;
                    end;
                }
                field("Sales Type";"Sales Type")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        if ("Sales Type"="sales type"::Prepayment) then
                             begin
                                "Paid AmountEditable" :=false;
                                "Customer NoEditable" :=true;
                             end
                           else begin
                                "Paid AmountEditable" :=true;
                                "Customer NoEditable" :=false;
                               // CurrForm.Balance.editable:=true;
                           end;
                    end;
                }
                field("Customer No";"Customer No")
                {
                    ApplicationArea = Basic;
                    Editable = "Customer NoEditable";

                    trigger OnValidate()
                    begin
                           Student.Reset;
                           Student.SetRange(Student."No.","Customer No") ;
                           if Student.Find('-') then
                           begin
                             "Customer Name":=Student.Name
                            end;
                    end;
                }
                field("Customer Name";"Customer Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Prepayment Balance";"Prepayment Balance")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Cashier Name";"Cashier Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Paid Amount";"Paid Amount")
                {
                    ApplicationArea = Basic;
                    Editable = "Paid AmountEditable";

                    trigger OnValidate()
                    begin
                            SalesLine.Reset;
                            Amt:=0;
                            SalesLine.SetRange(SalesLine."Receipt No","Receipt No");
                            if SalesLine.Find('-') then
                            begin
                             repeat
                               Amt:=Amt+SalesLine.Amount;
                             until SalesLine.Next=0;
                           end;
                           Balance:="Paid Amount"-Amt;
                    end;
                }
                field(Balance;Balance)
                {
                    ApplicationArea = Basic;
                    Editable = BalanceEditable;
                }
            }
            part(Control1000000000;"CAT-Menu Sales Line")
            {
                SubPageLink = "Receipt No"=field("Receipt No");
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Preview Receipt")
            {
                ApplicationArea = Basic;
                Caption = 'Preview Receipt';
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;

                trigger OnAction()
                begin
                      MenuSale.Reset;
                      MenuSale.SetRange(MenuSale."Receipt No","Receipt No");
                      if MenuSale.Find('-') then
                      Report.Run(39005646,true,true,MenuSale) ;
                end;
            }
            action("Post / Receipt")
            {
                ApplicationArea = Basic;
                Caption = 'Post / Receipt';
                Promoted = true;
                PromotedCategory = Process;
                ShortCutKey = 'F12';

                trigger OnAction()
                begin

                        if PostJrn() =true then begin
                        MenuSale.SetFilter(MenuSale."Receipt No","Receipt No");
                        if MenuSale.Find('-') then
                        Report.Run(51240,true,false,MenuSale) ;
                        CalcFields(Amount);
                        "Line Amount":=Amount;
                         Posted:=true;
                        Modify;
                        end;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
           SetFilter("Cashier Name",UserId);
    end;

    trigger OnInit()
    begin
        "Paid AmountEditable" := true;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
              "Cashier Name":=UserId;
               //"Sales Point":='MESS';
               SaleSetUp.Get();
               "Receiving Bank":=SaleSetUp."Receiving Bank Account";
    end;

    var
        Student: Record Customer;
        BankLedger: Record "Bank Account Ledger Entry";
        SalesLine: Record UnknownRecord61173;
        Amt: Decimal;
        "Line No": Integer;
        MenuRec: Record UnknownRecord61169;
        "Cashier Rec": Record Customer;
        MenuSale: Record UnknownRecord61170;
        GrnLine: Record "Gen. Journal Line";
        SaleSetUp: Record UnknownRecord61171;
        Temp: Text[30];
        Batch: Text[30];
        [InDataSet]
        "Paid AmountEditable": Boolean;
        [InDataSet]
        BalanceEditable: Boolean;
        CateringL: Record UnknownRecord61176;
        GLEntry: Record "G/L Entry";
        LastEntry: Integer;
        "Customer NoEditable": Boolean;


    procedure UpdateCashBox()
    begin
         //------------------BKK--------------

        BankLedger.Reset;
        SalesLine.Reset;
        MenuRec.Reset;
         if ("Customer Type"<>"customer type"::Staff) and ("Customer Type"<>"customer type"::Department) then
           begin

          Amt:=0;
          TestField(Date) ;
          //TESTFIELD("Cashier No");
          TestField("Receiving Bank");
          //TESTFIELD("Paid Amount");
          if Balance<0 then
          begin
           Error('The Paid Amount Is Less By '+Format(Balance))
          end;
          if BankLedger.FindLast() then
          begin
           "Line No":=BankLedger."Entry No."+1
          end
          else begin
           "Line No":=1
          end;
          SalesLine.SetRange(SalesLine."Receipt No","Receipt No");
          if SalesLine.Find('-') then
          begin
          repeat
            Amt:=Amt+SalesLine.Amount;
           until SalesLine.Next=0;
         end;

          if Amt=0 then begin
           Error('There is Nothing In The Sales Line')
          end;

          BankLedger.Init;
          BankLedger."Entry No.":="Line No";
          BankLedger."Bank Account No.":="Receiving Bank";
          BankLedger."Posting Date":=Date;
          BankLedger."Document No.":="Receipt No";
          BankLedger.Description:="Receipt No"+' '+"Customer Name";
          BankLedger.Amount:=Amt;
          BankLedger."Remaining Amount":=Amt;
          BankLedger."Amount (LCY)":=Amt;
          BankLedger."User ID":="Cashier No";
          BankLedger.Open:=true;
          BankLedger."Document Date":=Date;
          BankLedger.Insert(true) ;
        end;
        SalesLine.Reset;
        SalesLine.SetRange(SalesLine."Receipt No","Receipt No");
        if SalesLine.Find('-') then
        begin
          repeat
           MenuRec.Reset;
           MenuRec.SetRange(MenuRec."Menu Date",Date);
           MenuRec.SetRange(MenuRec.Menu,SalesLine.Menu);
          // MenuRec.SETRANGE(MenuRec.Type,MenuRec.Type::Student);
           if MenuRec.Find('-') then
           begin
            MenuRec."Remaining Qty":=MenuRec."Remaining Qty"-SalesLine.Quantity;
            MenuRec.Modify;
          end;
          until SalesLine.Next=0;
         end;

        //MESSAGE('Money Taken') ;
    end;


    procedure PostJrn() Posted: Boolean
    begin
           Posted:=false;
          TestField(Date) ;
          //TESTFIELD("Paid Amount");
          //TESTFIELD("Cashier);
          //TESTFIELD("Receiving Bank");
          if Balance<0 then
          begin
           Error('The Paid Amount Is Less By '+Format(Balance))
          end;

          Amt:=0;
          SalesLine.SetRange(SalesLine."Receipt No","Receipt No");
          if SalesLine.Find('-') then
          begin
          repeat
            Amt:=Amt+SalesLine.Amount;
           until SalesLine.Next=0;
          end;
          if Amt=0 then begin
           Error('There is Nothing In The Sales Line')
          end;
          if SaleSetUp.Get() then begin
           Temp:=SaleSetUp."Sales Template";
           Batch:=SaleSetUp."Sales Batch";
           SaleSetUp.TestField(SaleSetUp."Catering Income Account");
           SaleSetUp.TestField(SaleSetUp."Catering Control Account");
           SaleSetUp.TestField(SaleSetUp."Receiving Bank Account");
          end else begin
           Error('Enter The Sales Template And Batch In Catering SetUp')
          end;
          "Receiving Bank":=SaleSetUp."Receiving Bank Account";
          if "Sales Type"="sales type"::Cash then begin
         TestField("Paid Amount");
         GrnLine.Reset;
         GrnLine.SetRange(GrnLine."Journal Template Name",Temp);
         GrnLine.SetRange(GrnLine."Journal Batch Name",Batch);
         if GrnLine.Find('-') then begin
         GrnLine.DeleteAll;
         end;

         GrnLine.Init;
         GrnLine."Journal Template Name":=Temp;
         GrnLine."Journal Batch Name":=Batch;
         GrnLine."Line No.":="Line No";
         GrnLine."Account Type":=GrnLine."account type"::"Bank Account";
         GrnLine."Account No.":="Receiving Bank";
         GrnLine."Posting Date":=Date;
         GrnLine."Document Type":=0;
         GrnLine."Document No.":="Receipt No";
         GrnLine.Description:='Food Sale - '+"Customer No";
         GrnLine."Bal. Account No.":=SaleSetUp."Catering Income Account";
         GrnLine."Bal. Account Type":=GrnLine."bal. account type"::"G/L Account";
         GrnLine.Amount:=Amt;
         //GrnLine."Shortcut Dimension 1 Code":='MAIN';
        // GrnLine.VALIDATE(GrnLine."Shortcut Dimension 1 Code");
        // GrnLine."Shortcut Dimension 3 Code":='170';
        // GrnLine.VALIDATE(GrnLine."Shortcut Dimension 2 Code");
         GrnLine.Insert(true);

        end;

        if "Sales Type"="sales type"::Prepayment then begin
        // MenuSale.TESTFIELD(MenuSale."Customer No");
         CalcFields("Prepayment Balance");
         CalcFields(Amount);
         if ("Prepayment Balance"-Amount)<0 then Error('The Prepayment balance is not sufficient for the selected transaction');

         GrnLine.Reset;
         GrnLine.SetRange(GrnLine."Journal Template Name",Temp);
         GrnLine.SetRange(GrnLine."Journal Batch Name",Batch);
         if GrnLine.Find('-') then begin
         GrnLine.DeleteAll;
         end;

         GrnLine.Init;
         GrnLine."Journal Template Name":=Temp;
         GrnLine."Journal Batch Name":=Batch;
         GrnLine."Line No.":="Line No";
         GrnLine."Account Type":=GrnLine."account type"::"G/L Account";
         GrnLine."Account No.":=SaleSetUp."Catering Control Account";
         GrnLine."Posting Date":=Date;
         GrnLine."Document Type":=0;
         GrnLine."Document No.":="Receipt No";
         GrnLine.Description:='Food Sale - '+"Customer No";
         GrnLine."Bal. Account No.":=SaleSetUp."Catering Income Account";
         GrnLine."Bal. Account Type":=GrnLine."bal. account type"::"G/L Account";
         GrnLine.Amount:=Amt;
         Posted:=true;
         Modify;
         //GrnLine."Shortcut Dimension 1 Code":='MAIN';
        // GrnLine.VALIDATE(GrnLine."Shortcut Dimension 1 Code");
        // GrnLine."Shortcut Dimension 3 Code":='170';
        // GrnLine.VALIDATE(GrnLine."Shortcut Dimension 2 Code");
         GrnLine.Insert(true);

        end;
        if GLEntry.FindLast() then LastEntry:=GLEntry."Entry No.";
         GrnLine.Reset;
         GrnLine.SetRange(GrnLine."Journal Template Name",Temp) ;
         GrnLine.SetRange(GrnLine."Journal Batch Name",Batch);
         if GrnLine.Find('-') then begin
          Codeunit.Run(Codeunit::"Gen. Jnl.-Post B2",GrnLine);
         end;
         // Confirm if posted
         if GLEntry.FindLast() then
         if LastEntry<>GLEntry."Entry No." then Posted:=true;

        if Posted=true then begin
        if "Sales Type"="sales type"::Prepayment then begin
        if CateringL.FindLast() then
        "Line No":= "Line No"+1;
        "Line No":=CateringL."Entry No";
        CateringL.Init;
        CateringL."Entry No":="Line No"+1;
        CateringL."Customer No":="Customer No";
        CateringL."Entry Type":=CateringL."entry type"::Consumption;
        CateringL.Date:=Today;
        CateringL.Description:='Food Sales';
        CateringL.Amount:=Amount*-1;
        CateringL."User ID":=UserId;
        CateringL.Insert;

        SalesLine.Reset;
        SalesLine.SetRange(SalesLine."Receipt No","Receipt No");
        if SalesLine.Find('-') then
        begin
          repeat
           MenuRec.Reset;
           MenuRec.SetRange(MenuRec."Menu Date",Date);
           MenuRec.SetRange(MenuRec.Menu,SalesLine.Menu);
          // MenuRec.SETRANGE(MenuRec.Type,MenuRec.Type::Student);
           if MenuRec.Find('-') then
           begin
            MenuRec."Remaining Qty":=MenuRec."Remaining Qty"-SalesLine.Quantity;
            MenuRec.Modify;
          end;
          until SalesLine.Next=0;
         end;
        end;
        end;
    end;

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;
             //  "Customer Type":="Customer Type"::Student;
              "Cashier Name":=UserId;
    end;
}

