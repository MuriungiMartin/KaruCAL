#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68297 "CAT-Daily Menu"
{
    PageType = Document;
    SourceTable = UnknownTable61169;
    SourceTableView = where(Posted=const(No));

    layout
    {
        area(content)
        {
            field(MenuDate;MenuDate)
            {
                ApplicationArea = Basic;
                Caption = 'Menu Date';

                trigger OnValidate()
                begin
                         "Menu Date":=MenuDate;
                          SetRange("Menu Date",MenuDate);
                end;
            }
            repeater(Control1000000000)
            {
                field(Menu;Menu)
                {
                    ApplicationArea = Basic;
                    LookupPageID = "CAT-Menu List";

                    trigger OnValidate()
                    begin
                               "Menu Date":=MenuDate;

                              // TESTFIELD("Menu Date");
                               MenuRec.SetRange(MenuRec.Code,Menu) ;
                               if MenuRec.Find('-') then
                                  begin
                                    Description:=MenuRec.Description;
                                    Units:=MenuRec."Units Of Measure";
                                    "Menu Qty":=MenuRec.Quantity;
                                     "Unit Cost":=MenuRec.Amount;
                                     Type:=MenuRec.Type;
                                  end;
                    end;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Units;Units)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Menu Qty";"Menu Qty")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Total Qty";"Total Qty")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Yield;Yield)
                {
                    ApplicationArea = Basic;
                    Caption = 'Used Receipe';
                }
                field("Prod Qty";"Prod Qty")
                {
                    ApplicationArea = Basic;
                    Caption = 'Yield';

                    trigger OnValidate()
                    begin
                            "Total Qty":="Menu Qty"*"Prod Qty";
                            "Total Cost":="Total Qty"*"Unit Cost";
                    end;
                }
                field("Unit Cost";"Unit Cost")
                {
                    ApplicationArea = Basic;
                }
                field("Total Cost";"Total Cost")
                {
                    ApplicationArea = Basic;
                }
                field("Remaining Qty";"Remaining Qty")
                {
                    ApplicationArea = Basic;
                }
                field("Campus Code";"Campus Code")
                {
                    ApplicationArea = Basic;
                }
                field("Department Code";"Department Code")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Post)
            {
                Caption = 'Post';
                action("Update Stock")
                {
                    ApplicationArea = Basic;
                    Caption = 'Update Stock';

                    trigger OnAction()
                    begin
                            // Track The Last Entry
                             TestField("Campus Code");
                             TestField("Department Code");
                                if ItemLedger.Find('-') then
                               begin
                                 ItemLedger.FindLast();
                                 LastLedger:=ItemLedger."Entry No.";
                               end;
                           // Post The Journal
                              "Post Inventory"();

                           // Update The Menu If Posting Was Done
                              if ItemLedger.Find('-') then
                               begin
                                 if LastLedger<>ItemLedger."Entry No." then
                                    begin
                                    SetRange("Menu Date",MenuDate);
                                    if Find('-') then
                                    begin
                                      repeat
                                       "Remaining Qty":="Total Qty";
                                       "produced By":=UserId;
                                        Posted:=true;
                                       "Posted Date":=Today;
                                       Modify;
                                      until Next=0;
                                     end;
                                    end;
                                end;
                    end;
                }
                action("Update Stock / Print Menu")
                {
                    ApplicationArea = Basic;
                    Caption = 'Update Stock / Print Menu';

                    trigger OnAction()
                    begin
                            // Track The Last Entry
                              if ItemLedger.Find('-') then
                               begin
                                 ItemLedger.FindLast();
                                 LastLedger:=ItemLedger."Entry No.";
                               end;
                           // Post The Journal
                              "Post Inventory"();

                            // Print Menu
                              SetRange("Menu Date","Menu Date");
                              Report.Run(51161,false,false,Rec);

                           // Update The Menu If Posting Was Done
                              if ItemLedger.Find('-') then
                               begin
                                 if LastLedger<>ItemLedger."Entry No." then
                                    begin
                                      "produced By":=UserId;
                                       Posted:=true;
                                      "Posted Date":=Today;
                                      Modify;
                                    end;
                                end;
                    end;
                }
                action("Preview Menu")
                {
                    ApplicationArea = Basic;
                    Caption = 'Preview Menu';

                    trigger OnAction()
                    begin
                              SetRange("Menu Date","Menu Date");
                              Report.Run(51161,true,true,Rec);
                    end;
                }
            }
        }
        area(processing)
        {
            action("Get Left Overs")
            {
                ApplicationArea = Basic;
                Caption = 'Get Left Overs';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                        Page.Run(39005757);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
             MenuDate:="Menu Date";
    end;

    trigger OnOpenPage()
    begin
           MenuDate:=Today;
    end;

    var
        MenuDate: Date;
        MenuRec: Record UnknownRecord61167;
        Item: Record Item;
        ITMJnl: Record "Item Journal Line";
        GenSetUp: Record "General Ledger Setup";
        "Line No": Integer;
        MenuLine: Record UnknownRecord61168;
        str: Code[10];
        ItemLedger: Record "Item Ledger Entry";
        LastLedger: Integer;


    procedure "Post Inventory"()
    begin
        // Test Items To Be posted
         str:='';
         SetRange("Menu Date",MenuDate);
         SetFilter(Menu,'<>%1',str) ;
         if Find('-') then
          begin
          end
          else begin
            Error('There is Nothing To Be Posted Make Sure You Have Entered The Menu Date')
          end;
         TestField("Prod Qty");

        // Clean The Items Journal Line

          GenSetUp.Get();
          ITMJnl.SetRange(ITMJnl."Journal Template Name",GenSetUp."Item Template") ;
          ITMJnl.SetRange(ITMJnl."Journal Batch Name",GenSetUp."Item Batch");
          if ITMJnl.Find('-') then
             begin
               repeat
                ITMJnl.Delete;
               until ITMJnl.Next=0;
             end;

        // Populate The Journal Line
           "Line No":=10000;
           if Find('-') then
             begin
             repeat
               MenuLine.SetRange(MenuLine.Menu,Menu);
               MenuLine.SetRange(MenuLine.Type,Type) ;
               if MenuLine.Find('-') then
               begin
                repeat
                 ITMJnl.Init();
                 ITMJnl."Journal Template Name":=GenSetUp."Item Template";
                 ITMJnl."Journal Batch Name":=GenSetUp."Item Batch";
                 ITMJnl."Line No.":="Line No";
                 ITMJnl."Posting Date":=MenuDate;
                 ITMJnl."Entry Type":=ITMJnl."entry type"::"Negative Adjmt.";
                 ITMJnl.Quantity:="Total Qty";
                 ITMJnl."Unit Cost":="Unit Cost";
                 ITMJnl."Unit Amount":="Unit Cost";
                 ITMJnl.Amount:="Total Cost";
                 ITMJnl."Location Code":=MenuLine.Location;
                 ITMJnl."Gen. Prod. Posting Group":='CATERING';
                 ITMJnl."Gen. Bus. Posting Group":='LOCAL';
                 ITMJnl."Item No.":=MenuLine."Item No";
                 ITMJnl.Description:=MenuLine.Description;
                 ITMJnl."Document No.":=Format("Menu Date") +' '+Menu;
                 ITMJnl.Validate(ITMJnl.Quantity);
                 ITMJnl."Shortcut Dimension 1 Code":="Campus Code";
                 ITMJnl."Shortcut Dimension 2 Code":="Department Code";
                 ITMJnl.Insert(true);
                 "Line No":="Line No"+10000;
                until ITMJnl.Next=0;
               end;
             until Next=0;
            end;

          ITMJnl.SetRange(ITMJnl."Journal Template Name",GenSetUp."Item Template") ;
          ITMJnl.SetRange(ITMJnl."Journal Batch Name",GenSetUp."Item Batch");
          if ITMJnl.Find('-') then
          begin
            Codeunit.Run(Codeunit::"Item Jnl.-Post",ITMJnl)
          end;
        //MESSAGE('Inventory Updated Successfully');
    end;

    local procedure MenuOnAfterInput(var Text: Text[1024])
    begin
            MenuDate:="Menu Date";
    end;
}

