#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 78010 "Graduation Preocessing"
{
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    SourceTable = UnknownTable78007;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'Specify Parameters Here';
                field(GradYearCode;GradYearCode)
                {
                    ApplicationArea = Basic;
                    Caption = 'Graduation year';
                    TableRelation = "ACA-Academic Year".Code;
                }
                field(ProgrammeCode;ProgrammeCode)
                {
                    ApplicationArea = Basic;
                    Caption = 'Programme Code';
                    TableRelation = "ACA-Programme".Code;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(GenReport)
            {
                ApplicationArea = Basic;
                Caption = 'Generate Report';
                Image = WarehouseSetup;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    //

                    if ((GradYearCode='') or (ProgrammeCode='')) then Error('Specify the graduation Academic year and Programme');
                    Clear(GroupArray);
                    Clear(CountedLoops);
                    Clear(SaltedArray);
                       FinConsolidMarksheetCntrl.Reset;
                       FinConsolidMarksheetCntrl.SetRange("Grad. Academic Year",GradYearCode);
                       FinConsolidMarksheetCntrl.SetRange("Programme Code",ProgrammeCode);
                       if FinConsolidMarksheetCntrl.Find('-') then;
                    ////// BEGIN
                    // // //    REPEAT
                    // // //        BEGIN
                    FinConsolidMarksheetCntrl2.Reset;
                    FinConsolidMarksheetCntrl2.SetRange("Grad. Academic Year",GradYearCode);
                    FinConsolidMarksheetCntrl2.SetRange("Programme Code",ProgrammeCode);
                    //FinConsolidMarksheetCntrl2.SETRANGE("Academic Year",FinConsolidMarksheetCntrl."Academic Year");
                    //FinConsolidMarksheetCntrl2.SETRANGE("Year of Study",FinConsolidMarksheetCntrl."Year of Study");
                    if FinConsolidMarksheetCntrl2.Find('-') then begin
                        repeat
                            begin
                      Clear(SaltedArray);
                            SaltedArray:=FinConsolidMarksheetCntrl2."Grad. Academic Year"+FinConsolidMarksheetCntrl2."Programme Code"
                            +FinConsolidMarksheetCntrl2."Academic Year"+Format(FinConsolidMarksheetCntrl2."Year of Study");
                            CountedLoops:=CountedLoops+1;
                            FinConsolidMarksheetCntrl3.Reset;
                            FinConsolidMarksheetCntrl3.SetRange("Grad. Academic Year",FinConsolidMarksheetCntrl2."Grad. Academic Year");
                            FinConsolidMarksheetCntrl3.SetRange("Programme Code",FinConsolidMarksheetCntrl2."Programme Code");
                            FinConsolidMarksheetCntrl3.SetRange("Academic Year",FinConsolidMarksheetCntrl2."Academic Year");
                            FinConsolidMarksheetCntrl3.SetRange("Programme Option",FinConsolidMarksheetCntrl2."Programme Option");
                            FinConsolidMarksheetCntrl3.SetRange("Year of Study",FinConsolidMarksheetCntrl2."Year of Study");
                            if FinConsolidMarksheetCntrl3.Find('-') then;
                            //Weka tu.. Hata kama iko.. Kwani?
                              if CountedLoops= 1 then  begin
                                // Check if Option is in the Counted GroupArray
                                //Load REPORT Report 1
                                if CountedLoops=1 then begin
                                if not (SaltedArray in [GroupArray[1]]) then begin
                                  //Call Report 1 if Permutation for this does not exist
                                  Report.Run(78013,true,false,FinConsolidMarksheetCntrl3);
                                  end;
                                  end else begin
                                if not (SaltedArray in [GroupArray[1]..GroupArray[CountedLoops-1]]) then begin
                                  //Call Report 1 if Permutation for this does not exist
                                  Report.Run(78013,true,false,FinConsolidMarksheetCntrl3);
                                  end;
                                    end;
                                end else begin
                               // Load REPORT 2
                                if not (SaltedArray in [GroupArray[1]..GroupArray[CountedLoops-1]]) then begin
                                  //Call Report 2 if Permutation for this does not exist
                                  Report.Run(78016,true,false,FinConsolidMarksheetCntrl3);
                                  end;
                                end;
                            GroupArray[CountedLoops]:=SaltedArray;
                            end;
                          until FinConsolidMarksheetCntrl2.Next=0;
                      end;
                    // // //        END;
                    // // //      UNTIL FinConsolidMarksheetCntrl.NEXT=0;
                    // // //              REPORT.RUN(78017,TRUE,FALSE,FinConsolidMarksheetCntrl);
                    // // //  END;

                    //
                end;
            }
        }
    }

    var
        GradYearCode: Code[20];
        ProgrammeCode: Code[20];
        GroupArray: array [1000] of Code[50];
        FinConsolidMarksheetCntrl: Record UnknownRecord78007;
        FinConsolidMarksheetCntrl2: Record UnknownRecord78007;
        CountedLoops: Integer;
        SaltedArray: Code[250];
        FinConsolidMarksheetCntrl3: Record UnknownRecord78007;
}

