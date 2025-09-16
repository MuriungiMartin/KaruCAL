#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68014 "GEN-Journal Buffer"
{
    Editable = false;
    PageType = List;
    SourceTable = UnknownTable61000;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Bank Account No.";"Bank Account No.")
                {
                    ApplicationArea = Basic;
                }
                field("Statement No.";"Statement No.")
                {
                    ApplicationArea = Basic;
                }
                field("Statement Line No.";"Statement Line No.")
                {
                    ApplicationArea = Basic;
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic;
                }
                field("Transaction Date";"Transaction Date")
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field("Statement Amount";"Statement Amount")
                {
                    ApplicationArea = Basic;
                }
                field(Difference;Difference)
                {
                    ApplicationArea = Basic;
                }
                field("Applied Amount";"Applied Amount")
                {
                    ApplicationArea = Basic;
                }
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                }
                field("Applied Entries";"Applied Entries")
                {
                    ApplicationArea = Basic;
                }
                field("Value Date";"Value Date")
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
            action("Post Journals")
            {
                ApplicationArea = Basic;
                Caption = 'Post Journals';

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
                    Clear(lineno);
                    missing.Reset;
                    if missing.Find('-') then
                    missing.DeleteAll;
                    
                    janBuff.Reset;
                    //janBuff.SETRANGE(janBuff."Value Date",FALSE);
                    if janBuff.Find('-') then begin
                    if Confirm('Post Journals?',true)=false then exit;
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
                    progre.Open('Processing Please wait..............\#1###############################################################'+
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
                        counts:=counts+1;
                    
                        if cust.Get(janBuff."Document No.") then begin
                        lineno:=lineno+1;
                        genjn.Init;
                        //genjn."Journal Template Name" :=janBuff.Type;
                        //genjn."Journal Batch Name" :=janBuff."Applied Entries";
                       // genjn."Line No." :=janBuff."Line No.";
                        genjn."Line No." :=lineno;
                        genjn."Account Type" :=janBuff."Statement Line No.";
                        genjn."Account No." :=janBuff."Document No.";
                        //genjn."Posting Date" :=janBuff."Bank Account No.";
                        genjn."Document No." :=janBuff."Statement No.";
                        //IF (STRLEN(janBuff."Transaction Date"))>30 THEN
                        //genjn.Description :=COPYSTR(janBuff."Transaction Date",1,30)
                        //ELSE genjn.Description :=janBuff."Transaction Date";
                        //genjn.Amount =janBuff.Description;
                        //genjn."Bal. Account No." :=janBuff.Difference;
                        //genjn."Bal. Account Type" :=janBuff."Statement Amount";
                        genjn.Insert;
                       // janBuff."Value Date":=TRUE;
                        janBuff.Modify;
                        end
                        else begin
                          missing.Reset;
                          missing.SetRange(missing."Student No.",janBuff."Document No.");
                          if not missing.Find('-') then begin
                            missing.Init;
                            missing."Student No.":=janBuff."Document No.";
                            missing.Insert;
                          end;
                        end;
                    
                    Clear(Var1);
                    /*
                        IF counts=1 THEN
                        //RecCount1:=FORMAT(counts)+'). '+janBuff."Document No."+':'+janBuff."Transaction Date"
                        ELSE IF counts=2 THEN BEGIN
                        RecCount2:=FORMAT(counts)+'). '+janBuff."Document No."+':'+janBuff."Transaction Date";
                        END
                        ELSE IF counts=3 THEN BEGIN
                        RecCount3:=FORMAT(counts)+'). '+janBuff."Document No."+':'+janBuff."Transaction Date";
                        END
                        ELSE IF counts=4 THEN BEGIN
                        RecCount4:=FORMAT(counts)+'). '+janBuff."Document No."+':'+janBuff."Transaction Date";
                        END
                        ELSE IF counts=5 THEN BEGIN
                        RecCount5:=FORMAT(counts)+'). '+janBuff."Document No."+':'+janBuff."Transaction Date";
                        END
                        ELSE IF counts=6 THEN BEGIN
                        RecCount6:=FORMAT(counts)+'). '+janBuff."Document No."+':'+janBuff."Transaction Date";
                        END
                        ELSE IF counts=7 THEN BEGIN
                        RecCount7:=FORMAT(counts)+'). '+janBuff."Document No."+':'+janBuff."Transaction Date";
                        END
                        ELSE IF counts=8 THEN BEGIN
                        RecCount8:=FORMAT(counts)+'). '+janBuff."Document No."+':'+janBuff."Transaction Date";
                        END
                        ELSE IF counts=9 THEN BEGIN
                        RecCount9:=FORMAT(counts)+'). '+janBuff."Document No."+':'+janBuff."Transaction Date";
                        END
                        ELSE IF counts=10 THEN BEGIN
                        RecCount10:=FORMAT(counts)+'). '+janBuff."Document No."+':'+janBuff."Transaction Date";
                        END ELSE IF counts>10 THEN BEGIN
                        RecCount1:=RecCount2;
                        RecCount2:=RecCount3;
                        RecCount3:=RecCount4;
                        RecCount4:=RecCount5;
                        RecCount5:=RecCount6;
                        RecCount6:=RecCount7;
                        RecCount7:=RecCount8;
                        RecCount8:=RecCount9;
                        RecCount9:=RecCount10;
                        RecCount10:=FORMAT(counts)+'). '+janBuff."Document No."+':'+janBuff."Transaction Date";
                        END;
                        CLEAR(BufferString);
                        BufferString:='Total Records processed = '+FORMAT(counts);
                    
                        progre.UPDATE();
                        */
                          end;
                     until  ((janBuff.Next=0) or (counts=10000));
                     ////Progress Window
                     progre.Close;
                     Message( BufferString);
                    
                    end;
                    
                    genjn.Reset;
                    genjn.SetRange(genjn."Journal Template Name",'GENERAL');
                    genjn.SetRange(genjn."Journal Batch Name",'TRANS');
                    genjn.SetFilter(genjn.Amount,'<>%1',0);
                    if genjn.Find('-') then begin
                     Codeunit.Run(Codeunit::"Gen. Jnl.-Post",genjn);
                     end;

                end;
            }
            action("Missing Students")
            {
                ApplicationArea = Basic;
                Caption = 'Missing Students';
                RunObject = Page "ACA-Missing Students";
            }
        }
    }

    var
        cust: Record Customer;
        genjn: Record "Gen. Journal Line";
        janBuff: Record UnknownRecord61000;
        lineno: Integer;
        missing: Record UnknownRecord61008;
}

