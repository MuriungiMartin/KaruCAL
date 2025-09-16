#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69079 "CAT-Cafe. Meal Journal Line"
{
    PageType = List;
    SourceTable = UnknownTable61787;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Template;Template)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Batch;Batch)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Line No.";"Line No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic;
                }
                field("Transaction Type";"Transaction Type")
                {
                    ApplicationArea = Basic;
                }
                field("Cafeteria Section";"Cafeteria Section")
                {
                    ApplicationArea = Basic;
                }
                field("Meal Code";"Meal Code")
                {
                    ApplicationArea = Basic;
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                }
                field("Unit Price";"Unit Price")
                {
                    ApplicationArea = Basic;
                }
                field("Meal Description";"Meal Description")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Line Amount";"Line Amount")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            group(Posting)
            {
                Caption = 'Journal posting';
                action(post)
                {
                    ApplicationArea = Basic;
                    Caption = 'Post Inventory';
                    Image = PostBatch;
                    Promoted = true;

                    trigger OnAction()
                    var
                        progre: Dialog;
                        counts: Integer;
                        RecCount1: Text[120];
                        RecCount2: Text[120];
                        RecCount3: Text[120];
                        RecCount4: Text[120];
                        RecCount5: Text[120];
                        RecCount6: Text[120];
                        RecCount7: Text[120];
                        RecCount8: Text[120];
                        RecCount9: Text[120];
                        RecCount10: Text[120];
                        BufferString: Text[1024];
                        Var1: Code[10];
                    begin
                         if Confirm('Post meals inventory Journal?',true)=false then Error('Cancelled by user!');
                         mealjournal.Reset;
                         if mealjournal.Find('-') then begin
                         if ((mealjournal."Unit Price"=0) or (mealjournal.Quantity=0)) then
                          Error('The quantity and unit price should not be zero!');
                        Clear(RecCount1);
                        Clear(RecCount2);
                        Clear(RecCount3);
                        Clear(RecCount4);
                        Clear(RecCount5);
                        Clear(RecCount6);
                        Clear(RecCount7);
                        Clear(RecCount8);
                        Clear(RecCount9);
                        Clear(RecCount10);
                        Clear(counts);
                        progre.Open('Posting Please wait..............\#1###############################################################'+
                        '\#2###############################################################'+
                        '\#3###############################################################'+
                        '\#4###############################################################'+
                        '\#5###############################################################'+
                        '\#6###############################################################'+
                        '\#7###############################################################'+
                        '\#8###############################################################'+
                        '\#9###############################################################'+
                        '\#10###############################################################'+
                        '\#11###############################################################'+
                        '\#12###############################################################'+
                        '\#13###############################################################',
                            RecCount1,
                            RecCount2,
                            RecCount3,
                            RecCount4,
                            RecCount5,
                            RecCount6,
                            RecCount7,
                            RecCount8,
                            RecCount9,
                            RecCount10,
                            Var1,
                            Var1,
                            BufferString
                        );

                         repeat
                         begin
                         mealjournal.CalcFields(mealjournal."Meal Description");
                        Clear(Var1);
                            counts:=counts+1;
                            if counts=1 then
                            RecCount1:=Format(counts)+'). '+Format(mealjournal."Meal Code")+': '+mealjournal."Meal Description"

                            else if counts=2 then begin
                            RecCount2:=Format(counts)+'). '+Format(mealjournal."Meal Code")+': '+mealjournal."Meal Description"

                            end
                            else if counts=3 then begin
                            RecCount3:=Format(counts)+'). '+Format(mealjournal."Meal Code")+': '+mealjournal."Meal Description"

                            end
                            else if counts=4 then begin
                            RecCount4:=Format(counts)+'). '+Format(mealjournal."Meal Code")+': '+mealjournal."Meal Description"

                            end
                            else if counts=5 then begin
                            RecCount5:=Format(counts)+'). '+Format(mealjournal."Meal Code")+': '+mealjournal."Meal Description"

                            end
                            else if counts=6 then begin
                            RecCount6:=Format(counts)+'). '+Format(mealjournal."Meal Code")+': '+mealjournal."Meal Description"

                            end
                            else if counts=7 then begin
                            RecCount7:=Format(counts)+'). '+Format(mealjournal."Meal Code")+': '+mealjournal."Meal Description"

                            end
                            else if counts=8 then begin
                            RecCount8:=Format(counts)+'). '+Format(mealjournal."Meal Code")+': '+mealjournal."Meal Description"

                            end
                            else if counts=9 then begin
                            RecCount9:=Format(counts)+'). '+Format(mealjournal."Meal Code")+': '+mealjournal."Meal Description"

                            end
                            else if counts=10 then begin
                            RecCount10:=Format(counts)+'). '+Format(mealjournal."Meal Code")+': '+mealjournal."Meal Description"

                            end else if counts>10 then begin
                            RecCount1:=RecCount2;
                            RecCount2:=RecCount3;
                            RecCount3:=RecCount4;
                            RecCount4:=RecCount5;
                            RecCount5:=RecCount6;
                            RecCount6:=RecCount7;
                            RecCount7:=RecCount8;
                            RecCount8:=RecCount9;
                            RecCount9:=RecCount10;
                            RecCount10:=Format(counts)+'). '+Format(mealjournal."Meal Code")+': '+mealjournal."Meal Description";
                            end;
                            Clear(BufferString);
                            BufferString:='Total Records processed = '+Format(counts);

                            progre.Update();
                        // Check if the Item Exists in the Inventory for the specified date
                        itemInventory.Reset;
                        itemInventory.SetRange(itemInventory."Item No",mealjournal."Meal Code");
                        itemInventory.SetRange(itemInventory."Cafeteria Section",mealjournal."Cafeteria Section");
                        itemInventory.SetRange(itemInventory."Menu Date",mealjournal."Posting Date");
                        if not itemInventory.Find('-') then begin
                        // Create the Item
                          itemInventory.Init;
                            itemInventory."Item No":=mealjournal."Meal Code";
                            itemInventory.Category:=mealjournal.Category;
                            itemInventory."Price Per Item":=mealjournal."Unit Price";
                            itemInventory."Menu Date":=mealjournal."Posting Date";
                            itemInventory."Cafeteria Section":=mealjournal."Cafeteria Section";
                          itemInventory.Insert;
                        end else begin
                        itemInventory."Price Per Item":=mealjournal."Unit Price";
                        itemInventory.Modify;
                        end;
                           Clear(lineNo);
                           MealJournEntrie.Reset;
                           MealJournEntrie.SetRange(MealJournEntrie."Posting Date",mealjournal."Posting Date");
                           if MealJournEntrie.Find('-') then begin
                           lineNo:=MealJournEntrie.Count+10;
                           end else begin
                           lineNo:=10;
                           end;
                        // Create Ledger Entries for the Cafe Meal Items
                        MealJournEntrie.Init;
                          MealJournEntrie.Template:=mealjournal.Template;
                          MealJournEntrie.Batch:=mealjournal.Batch;
                          MealJournEntrie."Meal Code":=mealjournal."Meal Code";
                          MealJournEntrie."Posting Date":=mealjournal."Posting Date";
                          MealJournEntrie."Line No.":=lineNo;
                          MealJournEntrie."Cafeteria Section":=mealjournal."Cafeteria Section";
                          MealJournEntrie."Transaction Type":=mealjournal."Transaction Type";
                          if mealjournal."Transaction Type"=mealjournal."transaction type"::"Negative Adjustment" then
                          MealJournEntrie.Quantity:=mealjournal.Quantity*(-1)
                          else if mealjournal."Transaction Type"=mealjournal."transaction type"::"Positive Adjustment" then
                          MealJournEntrie.Quantity:=mealjournal.Quantity
                          else Error('The Transaction type should be either ''POSITIVE'' or ''Negative''');
                          MealJournEntrie."User Id":=mealjournal."User Id";
                          MealJournEntrie."Unit Price":=mealjournal."Unit Price";
                          MealJournEntrie."Line Amount":=mealjournal.Quantity*mealjournal."Unit Price";
                          MealJournEntrie."Meal Description":=mealjournal."Meal Description";
                        MealJournEntrie.Insert;


                        // Delete the journal for the specified date
                        mealjournal.Delete;
                              end;
                         until  mealjournal.Next=0;
                         progre.Close;
                         end;
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Reset;
        Rec.SetFilter(Rec."Posting Date",'=%1',Today);
        Rec.SetFilter(Rec.Template,'=%1','Cafe_Inventory');
        Rec.SetFilter(Rec.Batch,'=%1','Adjustment');
        Rec.SetFilter("User Id",'=%1',UserId);
    end;

    var
        mealjournal: Record UnknownRecord61787;
        MealJournEntrie: Record UnknownRecord61788;
        itemInventory: Record UnknownRecord61782;
        lineNo: Integer;
}

