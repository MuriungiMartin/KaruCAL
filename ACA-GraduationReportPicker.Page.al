#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 66611 "ACA-Graduation Report Picker"
{
    PageType = Card;
    SourceTable = UnknownTable66610;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("User ID";"User ID")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Graduation Academic Year";"Graduation Academic Year")
                {
                    ApplicationArea = Basic;
                }
                field(Programme;Programme)
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
            action(ClassificationList)
            {
                ApplicationArea = Basic;
                Caption = 'Classification List';
                Image = Agreement;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    YoSInt: Integer;
                    ACAClassificationHeader: Record UnknownRecord66612;
                    FinalSenateClassificationz: Report UnknownReport66611;
                begin
                    TestField("Graduation Academic Year");
                    TestField(Programme);
                    ACACourseRegistration.Reset;
                    ACAClassificationHeader.Reset;
                    if "Graduation Academic Year"<>'' then begin
                       ACAClassificationHeader.SetRange("Graduation Academic Year",Rec."Graduation Academic Year");
                       ACACourseRegistration.SetRange("Graduation Academic Year",Rec."Graduation Academic Year");
                      end;
                    if Programme<>'' then begin
                       ACACourseRegistration.SetRange(Programme,Rec.Programme);
                       ACAClassificationHeader.SetRange("Programme Code",Rec.Programme);
                      ACAProgrammeStages.Reset;
                      ACAProgrammeStages.SetRange("Programme Code",Programme);
                      ACAProgrammeStages.SetRange("Final Stage",true);
                      if ACAProgrammeStages.Find('+') then begin
                        Clear(YoSInt);
                        if Evaluate(YoSInt,CopyStr(ACAProgrammeStages.Code,2,1)) then  begin
                       ACAClassificationHeader.SetRange("Year of Study",YoSInt);
                          ACACourseRegistration.SetRange("Year Of Study",YoSInt);
                        end;
                      end;
                    end;
                    if ACACourseRegistration.Find('-') then;
                    if ACAClassificationHeader.Find('-') then;
                    Clear(YoSComputed);
                    Prog.Reset;
                    Prog.SetRange(Code,Rec.Programme);
                    if Prog.Find('-') then begin
                      ACAProgrammeStages.Reset;
                      ACAProgrammeStages.SetRange("Programme Code",Prog.Code);
                      ACAProgrammeStages.SetRange("Final Stage",true);
                      if ACAProgrammeStages.Find('-') then begin
                          if ((CopyStr(ACAProgrammeStages.Code,2,1)) in ['1','2','3','4','5','6','7']) then Evaluate(YoSComputed,CopyStr(ACAProgrammeStages.Code,2,1))
                          else Error('Final Stage of study has an invalid format!');
                        end else Error('Programme last stage is not defined!');
                      end else Error('Programme not Found!');

                    ACAClassificationHeader.Reset;
                    ACAClassificationHeader.SetRange("User ID",UserId);
                    ACAClassificationHeader.SetRange("Programme Code",Rec.Programme);
                    ACAClassificationHeader.SetRange("Graduation Academic Year",Rec."Graduation Academic Year");
                    if ACAClassificationHeader.Find('-') then ACAClassificationHeader.DeleteAll;
                    ACAClassificationDetails.Reset;
                    ACAClassificationDetails.SetRange("User ID",UserId);
                    ACAClassificationDetails.SetRange("Programme Code",Rec.Programme);
                    ACAClassificationDetails.SetRange("Graduation Academic Year",Rec."Graduation Academic Year");
                    if ACAClassificationDetails.Find('-') then ACAClassificationDetails.DeleteAll;
                    ACAClassGradRubrics.Reset;
                    if ACAClassGradRubrics.Find('-') then begin
                        repeat
                            begin
                              ACAClassificationHeader.Init;
                              ACAClassificationHeader."User ID":=UserId;
                              ACAClassificationHeader."Graduation Academic Year":=Rec."Graduation Academic Year";
                              ACAClassificationHeader."Classification Code":=ACAClassGradRubrics.Code;
                              ACAClassificationHeader."Classification Order":=ACAClassGradRubrics."Order No";
                              ACAClassificationHeader."Programme Code":=Rec.Programme;
                              if ACAClassGradRubrics.Code='INCOMPLETE' then begin
                              ACAClassificationHeader."Pass Status":='INCOMPLETE';
                              ACAClassificationHeader."Pass Status Order":=2;
                              end else begin
                              ACAClassificationHeader."Pass Status":='PASS';
                              ACAClassificationHeader."Pass Status Order":=1;
                              end;
                              ACAClassificationHeader."Year of Study":=YoSComputed;
                              ACAClassificationHeader."Year of Study Text":=GetYearofStudyText(YoSComputed);
                              ACAClassificationHeader.Msg1:=ACAClassGradRubrics."Classification Msg1";
                              ACAClassificationHeader.Msg2:=ACAClassGradRubrics."Classification Msg2";
                              ACAClassificationHeader.Msg3:=ACAClassGradRubrics."Classification Msg3";
                              ACAClassificationHeader.Msg4:=ACAClassGradRubrics."Classification Msg4";
                              ACAClassificationHeader.Msg5:=ACAClassGradRubrics."Classification Msg5";
                              ACAClassificationHeader.Msg6:=ACAClassGradRubrics."Classification Msg6";
                              ACAClassificationHeader."Final Year Comment":=ACAClassGradRubrics."Final Year Comment";
                              ACAClassificationHeader.Insert;
                            end;
                          until ACAClassGradRubrics.Next=0;
                      end;
                    Clear(ITmCourseReg);
                    ITmCourseReg.Reset;
                    ITmCourseReg.SetFilter(Status,'%1|%2|%3',ITmCourseReg.Status::Current,ITmCourseReg.Status::Registration,ITmCourseReg.Status::Deceased);
                    ITmCourseReg.SetRange(Programme,Rec.Programme);
                    ITmCourseReg.SetRange("Graduation Academic Year",Rec."Graduation Academic Year");
                    ITmCourseReg.SetRange(ITmCourseReg.Reversed,false);
                    ITmCourseReg.SetRange(ITmCourseReg."Year Of Study",YoSComputed);
                    // ITmCourseReg.COPYFILTERS(ACACourseRegistration);
                    if ITmCourseReg.Find('-') then  begin
                    // // // // // IF ACACourseRegistration.FIND('-') THEN BEGIN
                    // // // // //    REPORT.RUN(66610,FALSE,FALSE,ACACourseRegistration);
                    // // // // //  END;
                    //// Update Graduation Parameters
                    repeat
                      begin
                    // // // ITmCourseReg.CALCFIELDS(ITmCourseReg."Special Exam Exists");
                    // // // ITmCourseReg.CALCFIELDS(ITmCourseReg."Supp. Yearly Passed Units",ITmCourseReg."Supp. Yearly Failed Units");
                    // // // ITmCourseReg.CALCFIELDS(ITmCourseReg."Supp. Yearly Total Units Taken",ITmCourseReg."Is Final Year Student",
                    // // // ITmCourseReg."Graduation Status Count");
                    //////////////////..........................................................................

                    ACAClassificationHeader.Reset;
                    ACAClassificationHeader.SetRange("User ID",UserId);
                    ACAClassificationHeader.SetRange("Programme Code",Rec.Programme);
                    ACAClassificationHeader.SetRange("Graduation Academic Year",Rec."Graduation Academic Year");
                    ACAClassificationHeader.SetRange("Classification Code",ITmCourseReg."Final Clasification");
                    if ACAClassificationHeader.Find('-') then;
                    if Cust.Get(ITmCourseReg."Student No.") then;

                    ACAClassificationDetails.Reset;
                    ACAClassificationDetails.SetRange("User ID",UserId);
                    ACAClassificationDetails.SetRange("Programme Code",ITmCourseReg.Programme);
                    ACAClassificationDetails.SetRange("Graduation Academic Year",ITmCourseReg."Graduation Academic Year");
                    ACAClassificationDetails.SetRange("Student No.",ITmCourseReg."Student No.");
                    if not ACAClassificationDetails.Find('-') then begin

                              ACAClassificationDetails.Init;
                              ACAClassificationDetails."User ID":=UserId;
                              ACAClassificationDetails."Graduation Academic Year":=ITmCourseReg."Graduation Academic Year";
                              ACAClassificationDetails."Classification Code":=ITmCourseReg."Final Clasification";
                              ACAClassificationDetails."Programme Code":=ITmCourseReg.Programme;
                              ACAClassificationDetails."Student No.":=ITmCourseReg."Student No.";
                              ACAClassificationDetails."Student Name":=Cust.Name;
                              if ITmCourseReg."Final Clasification"='INCOMPLETE' then begin
                              ACAClassificationDetails."Pass Status":='INCOMPLETE';
                              end else begin
                              ACAClassificationDetails."Pass Status":='PASS';
                              end;
                              ACAClassificationDetails."Year of Study":=ITmCourseReg."Year Of Study";
                              ACAClassificationDetails."Class Order":=ACAClassificationHeader."Classification Order";
                              ACAClassificationDetails.Insert;
                      end else begin
                              ACAClassificationDetails."Classification Code":=ITmCourseReg."Final Clasification";
                              if ITmCourseReg."Final Clasification"='INCOMPLETE' then begin
                              ACAClassificationDetails."Pass Status":='INCOMPLETE';
                              end else begin
                              ACAClassificationDetails."Pass Status":='PASS';
                              end;
                              ACAClassificationDetails."Student Name":=Cust.Name;
                              ACAClassificationDetails."Year of Study":=ITmCourseReg."Year Of Study";
                              ACAClassificationDetails."Class Order":=ACAClassificationHeader."Classification Order";
                              ACAClassificationDetails.Modify;
                        end;
                        end;
                        until ITmCourseReg.Next=0;
                    end;
                    //Update Serials

                          Clear(incounts);
                            ACAClassificationDetails.Reset;
                            ACAClassificationDetails.SetRange("User ID",UserId);
                            ACAClassificationDetails.SetRange("Programme Code",Rec.Programme);
                            ACAClassificationDetails.SetRange("Graduation Academic Year",Rec."Graduation Academic Year");
                            ACAClassificationDetails.SetRange("Pass Status",'PASS');
                            ACAClassificationDetails.SetCurrentkey(ACAClassificationDetails."Student Name",ACAClassificationDetails."Pass Status",
                            ACAClassificationDetails."Classification Code",ACAClassificationDetails."Class Order");
                            if ACAClassificationDetails.Find('-') then begin
                              Clear(incounts);
                              repeat
                                begin
                                 incounts+=1;
                                 ACAClassificationDetails."Graduation Serial":=incounts;
                                 ACAClassificationDetails.Modify;
                                end;
                                until ACAClassificationDetails.Next=0;
                              end;

                    ACAClassificationHeader.Reset;
                    ACAClassificationHeader.SetRange("User ID",UserId);
                    ACAClassificationHeader.SetRange("Programme Code",Rec.Programme);
                    ACAClassificationHeader.SetRange("Graduation Academic Year",Rec."Graduation Academic Year");
                    if ACAClassificationHeader.Find('-') then begin
                        repeat
                          begin//Updating Graduation Numbering
                              /// Update Classification Numbering
                          Clear(incounts);
                            ACAClassificationDetails.Reset;
                            ACAClassificationDetails.SetRange("User ID",UserId);
                            ACAClassificationDetails.SetRange("Programme Code",Rec.Programme);
                            ACAClassificationDetails.SetRange("Graduation Academic Year",Rec."Graduation Academic Year");
                            ACAClassificationDetails.SetRange("Classification Code",ACAClassificationHeader."Classification Code");
                            ACAClassificationDetails.SetCurrentkey(ACAClassificationDetails."Student No.",ACAClassificationDetails."Classification Code");
                            if ACAClassificationDetails.Find('-') then begin
                              repeat
                                begin
                                 incounts+=1;
                                 ACAClassificationDetails."Classification Serial":=incounts;
                                 ACAClassificationDetails.Modify;
                                end;
                                until ACAClassificationDetails.Next=0;
                              end;

                          end;
                            until ACAClassificationHeader.Next=0;
                      end;
                    ACAClassificationHeader.Reset;
                    ACAClassificationHeader.SetRange("User ID",UserId);
                    ACAClassificationHeader.SetRange("Programme Code",Rec.Programme);
                    ACAClassificationHeader.SetRange("Graduation Academic Year",Rec."Graduation Academic Year");

                    if ACAClassificationHeader.Find('-') then begin
                       Report.RunModal(66611,false,false,ACAClassificationHeader);
                      end;
                end;
            }
            action("Graduation List")
            {
                ApplicationArea = Basic;
                Caption = 'Graduation List';
                Image = Agreement;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    YoSInt: Integer;
                    ACAClassificationHeader: Record UnknownRecord66612;
                    FinalSenateClassificationz: Report UnknownReport66611;
                    FinalGraduationList: Report UnknownReport66612;
                begin
                    TestField("Graduation Academic Year");
                    TestField(Programme);
                    ACACourseRegistration.Reset;
                    ACAClassificationHeader.Reset;
                    if "Graduation Academic Year"<>'' then begin
                       ACAClassificationHeader.SetRange("Graduation Academic Year",Rec."Graduation Academic Year");
                       ACACourseRegistration.SetRange("Graduation Academic Year",Rec."Graduation Academic Year");
                      end;
                    if Programme<>'' then begin
                       ACACourseRegistration.SetRange(Programme,Rec.Programme);
                       ACAClassificationHeader.SetRange("Programme Code",Rec.Programme);
                      ACAProgrammeStages.Reset;
                      ACAProgrammeStages.SetRange("Programme Code",Programme);
                      ACAProgrammeStages.SetRange("Final Stage",true);
                      if ACAProgrammeStages.Find('+') then begin
                        Clear(YoSInt);
                        if Evaluate(YoSInt,CopyStr(ACAProgrammeStages.Code,2,1)) then  begin
                       ACAClassificationHeader.SetRange("Year of Study",YoSInt);
                          ACACourseRegistration.SetRange("Year Of Study",YoSInt);
                        end;
                      end;
                    end;
                    if ACACourseRegistration.Find('-') then;
                    if ACAClassificationHeader.Find('-') then;
                    Clear(YoSComputed);
                    Prog.Reset;
                    Prog.SetRange(Code,Rec.Programme);
                    if Prog.Find('-') then begin
                      ACAProgrammeStages.Reset;
                      ACAProgrammeStages.SetRange("Programme Code",Prog.Code);
                      ACAProgrammeStages.SetRange("Final Stage",true);
                      if ACAProgrammeStages.Find('-') then begin
                          if ((CopyStr(ACAProgrammeStages.Code,2,1)) in ['1','2','3','4','5','6','7']) then Evaluate(YoSComputed,CopyStr(ACAProgrammeStages.Code,2,1))
                          else Error('Final Stage of study has an invalid format!');
                        end else Error('Programme last stage is not defined!');
                      end else Error('Programme not Found!');

                    ACAClassificationHeader.Reset;
                    ACAClassificationHeader.SetRange("User ID",UserId);
                    ACAClassificationHeader.SetRange("Programme Code",Rec.Programme);
                    ACAClassificationHeader.SetRange("Graduation Academic Year",Rec."Graduation Academic Year");
                    if ACAClassificationHeader.Find('-') then ACAClassificationHeader.DeleteAll;
                    ACAClassificationDetails.Reset;
                    ACAClassificationDetails.SetRange("User ID",UserId);
                    ACAClassificationDetails.SetRange("Programme Code",Rec.Programme);
                    ACAClassificationDetails.SetRange("Graduation Academic Year",Rec."Graduation Academic Year");
                    if ACAClassificationDetails.Find('-') then ACAClassificationDetails.DeleteAll;
                    ACAClassGradRubrics.Reset;
                    if ACAClassGradRubrics.Find('-') then begin
                        repeat
                            begin
                              ACAClassificationHeader.Init;
                              ACAClassificationHeader."User ID":=UserId;
                              ACAClassificationHeader."Graduation Academic Year":=Rec."Graduation Academic Year";
                              ACAClassificationHeader."Classification Code":=ACAClassGradRubrics.Code;
                              ACAClassificationHeader."Classification Order":=ACAClassGradRubrics."Order No";
                              ACAClassificationHeader."Programme Code":=Rec.Programme;
                              if ACAClassGradRubrics.Code='INCOMPLETE' then begin
                              ACAClassificationHeader."Pass Status":='INCOMPLETE';
                              ACAClassificationHeader."Pass Status Order":=2;
                              end else begin
                              ACAClassificationHeader."Pass Status":='PASS';
                              ACAClassificationHeader."Pass Status Order":=1;
                              end;
                              ACAClassificationHeader."Year of Study":=YoSComputed;
                              ACAClassificationHeader."Year of Study Text":=GetYearofStudyText(YoSComputed);
                              ACAClassificationHeader.Msg1:=ACAClassGradRubrics."Classification Msg1";
                              ACAClassificationHeader.Msg2:=ACAClassGradRubrics."Classification Msg2";
                              ACAClassificationHeader.Msg3:=ACAClassGradRubrics."Classification Msg3";
                              ACAClassificationHeader.Msg4:=ACAClassGradRubrics."Classification Msg4";
                              ACAClassificationHeader.Msg5:=ACAClassGradRubrics."Classification Msg5";
                              ACAClassificationHeader.Msg6:=ACAClassGradRubrics."Classification Msg6";
                              ACAClassificationHeader."Final Year Comment":=ACAClassGradRubrics."Final Year Comment";
                              ACAClassificationHeader.Insert;
                            end;
                          until ACAClassGradRubrics.Next=0;
                      end;
                    Clear(ITmCourseReg);
                    ITmCourseReg.Reset;
                    ITmCourseReg.SetFilter(Status,'%1|%2|%3',ITmCourseReg.Status::Current,ITmCourseReg.Status::Registration,ITmCourseReg.Status::Deceased);
                    ITmCourseReg.SetRange(Programme,Rec.Programme);
                    ITmCourseReg.SetRange("Graduation Academic Year",Rec."Graduation Academic Year");
                    ITmCourseReg.SetRange(ITmCourseReg.Reversed,false);
                    ITmCourseReg.SetRange(ITmCourseReg."Year Of Study",YoSComputed);
                    // ITmCourseReg.COPYFILTERS(ACACourseRegistration);
                    if ITmCourseReg.Find('-') then  begin
                    // // // // // IF ACACourseRegistration.FIND('-') THEN BEGIN
                    // // // // //    REPORT.RUN(66610,FALSE,FALSE,ACACourseRegistration);
                    // // // // //  END;
                    //// Update Graduation Parameters
                    repeat
                      begin
                    // // // ITmCourseReg.CALCFIELDS(ITmCourseReg."Special Exam Exists");
                    // // // ITmCourseReg.CALCFIELDS(ITmCourseReg."Supp. Yearly Passed Units",ITmCourseReg."Supp. Yearly Failed Units");
                    // // // ITmCourseReg.CALCFIELDS(ITmCourseReg."Supp. Yearly Total Units Taken",ITmCourseReg."Is Final Year Student",
                    // // // ITmCourseReg."Graduation Status Count");
                    //////////////////..........................................................................

                    ACAClassificationHeader.Reset;
                    ACAClassificationHeader.SetRange("User ID",UserId);
                    ACAClassificationHeader.SetRange("Programme Code",Rec.Programme);
                    ACAClassificationHeader.SetRange("Graduation Academic Year",Rec."Graduation Academic Year");
                    ACAClassificationHeader.SetRange("Classification Code",ITmCourseReg."Final Clasification");
                    if ACAClassificationHeader.Find('-') then;
                    if Cust.Get(ITmCourseReg."Student No.") then;

                    ACAClassificationDetails.Reset;
                    ACAClassificationDetails.SetRange("User ID",UserId);
                    ACAClassificationDetails.SetRange("Programme Code",ITmCourseReg.Programme);
                    ACAClassificationDetails.SetRange("Graduation Academic Year",ITmCourseReg."Graduation Academic Year");
                    ACAClassificationDetails.SetRange("Student No.",ITmCourseReg."Student No.");
                    if not ACAClassificationDetails.Find('-') then begin

                              ACAClassificationDetails.Init;
                              ACAClassificationDetails."User ID":=UserId;
                              ACAClassificationDetails."Graduation Academic Year":=ITmCourseReg."Graduation Academic Year";
                              ACAClassificationDetails."Classification Code":=ITmCourseReg."Final Clasification";
                              ACAClassificationDetails."Programme Code":=ITmCourseReg.Programme;
                              ACAClassificationDetails."Student No.":=ITmCourseReg."Student No.";
                              ACAClassificationDetails."Student Name":=Cust.Name;
                              if ITmCourseReg."Final Clasification"='INCOMPLETE' then begin
                              ACAClassificationDetails."Pass Status":='INCOMPLETE';
                              end else begin
                              ACAClassificationDetails."Pass Status":='PASS';
                              end;
                              ACAClassificationDetails."Year of Study":=ITmCourseReg."Year Of Study";
                              ACAClassificationDetails."Class Order":=ACAClassificationHeader."Classification Order";
                              ACAClassificationDetails.Insert;
                      end else begin
                              ACAClassificationDetails."Classification Code":=ITmCourseReg."Final Clasification";
                              if ITmCourseReg."Final Clasification"='INCOMPLETE' then begin
                              ACAClassificationDetails."Pass Status":='INCOMPLETE';
                              end else begin
                              ACAClassificationDetails."Pass Status":='PASS';
                              end;
                              ACAClassificationDetails."Student Name":=Cust.Name;
                              ACAClassificationDetails."Year of Study":=ITmCourseReg."Year Of Study";
                              ACAClassificationDetails."Class Order":=ACAClassificationHeader."Classification Order";
                              ACAClassificationDetails.Modify;
                        end;
                        end;
                        until ITmCourseReg.Next=0;
                    end;
                    //Update Serials

                          Clear(incounts);
                            ACAClassificationDetails.Reset;
                            ACAClassificationDetails.SetRange("User ID",UserId);
                            ACAClassificationDetails.SetRange("Programme Code",Rec.Programme);
                            ACAClassificationDetails.SetRange("Graduation Academic Year",Rec."Graduation Academic Year");
                            ACAClassificationDetails.SetRange("Pass Status",'PASS');
                            ACAClassificationDetails.SetCurrentkey(ACAClassificationDetails."Student Name",ACAClassificationDetails."Pass Status",
                            ACAClassificationDetails."Classification Code",ACAClassificationDetails."Class Order");
                            if ACAClassificationDetails.Find('-') then begin
                              Clear(incounts);
                              repeat
                                begin
                                 incounts+=1;
                                 ACAClassificationDetails."Graduation Serial":=incounts;
                                 ACAClassificationDetails.Modify;
                                end;
                                until ACAClassificationDetails.Next=0;
                              end;

                    ACAClassificationHeader.Reset;
                    ACAClassificationHeader.SetRange("User ID",UserId);
                    ACAClassificationHeader.SetRange("Programme Code",Rec.Programme);
                    ACAClassificationHeader.SetRange("Graduation Academic Year",Rec."Graduation Academic Year");
                    if ACAClassificationHeader.Find('-') then begin
                        repeat
                          begin//Updating Graduation Numbering
                              /// Update Classification Numbering
                          Clear(incounts);
                            ACAClassificationDetails.Reset;
                            ACAClassificationDetails.SetRange("User ID",UserId);
                            ACAClassificationDetails.SetRange("Programme Code",Rec.Programme);
                            ACAClassificationDetails.SetRange("Graduation Academic Year",Rec."Graduation Academic Year");
                            ACAClassificationDetails.SetRange("Classification Code",ACAClassificationHeader."Classification Code");
                            ACAClassificationDetails.SetCurrentkey(ACAClassificationDetails."Student No.",ACAClassificationDetails."Classification Code");
                            if ACAClassificationDetails.Find('-') then begin
                              repeat
                                begin
                                 incounts+=1;
                                 ACAClassificationDetails."Classification Serial":=incounts;
                                 ACAClassificationDetails.Modify;
                                end;
                                until ACAClassificationDetails.Next=0;
                              end;

                          end;
                            until ACAClassificationHeader.Next=0;
                      end;
                    ACAClassificationHeader.Reset;
                    ACAClassificationHeader.SetRange("User ID",UserId);
                    ACAClassificationHeader.SetRange("Programme Code",Rec.Programme);
                    ACAClassificationHeader.SetRange("Graduation Academic Year",Rec."Graduation Academic Year");

                    if ACAClassificationHeader.Find('-') then begin
                    // //    FinalGraduationList.SETTABLEVIEW(ACAClassificationHeader);
                    // //    FinalGraduationList.RUNMODAL;//
                       Report.RunModal(66612,false,false,ACAClassificationHeader);
                      end;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetFilter("User ID",UserId);
    end;

    trigger OnOpenPage()
    begin
        ACAGraduationReportPicker.Reset;
        ACAGraduationReportPicker.SetRange("User ID",UserId);
        if not ACAGraduationReportPicker.Find('-') then begin
          ACAGraduationReportPicker.Init;
          ACAGraduationReportPicker."User ID":=UserId;
          ACAGraduationReportPicker.Insert;
          end;
    end;

    var
        ACAGraduationReportPicker: Record UnknownRecord66610;
        GradAcdYear: Code[1024];
        YearOfStudy: Option " ","1","2","3","4","5","6","7";
        ProgFilters: Code[1024];
        ACACourseRegistration: Record UnknownRecord61532;
        ITmCourseReg: Record UnknownRecord61532;
        ACAProgramme: Record UnknownRecord61511;
        ACAProgrammeStages: Record UnknownRecord61516;
        YoSComputed: Integer;
        ACAClassificationHeader: Record UnknownRecord66612;
        ACAClassificationDetails: Record UnknownRecord66613;
        ACAClassificationDetails2: Record UnknownRecord66613;
        ACAClassGradRubrics: Record UnknownRecord78011;
        SpecialReason: Text[150];
        failExists: Boolean;
        StatusOrder: Integer;
        statusCompiled: Code[50];
        NotSpecialNotSuppSpecial: Boolean;
        isSpecialOnly: Boolean;
        IsSpecialAndSupp: Boolean;
        IsaForthYear: Boolean;
        IsSpecialUnit: Boolean;
        SpecialUnitReg1: Boolean;
        SpecialUnitReg: Boolean;
        ACASenateReportCounts: Record UnknownRecord77720;
        NoOfStudentInText: Text[250];
        ConvertDecimalToText: Codeunit "Convert Decimal To Text";
        PercentageFailedCaption: Text[100];
        NumberOfCoursesFailedCaption: Text[100];
        PercentageFailedValue: Decimal;
        NoOfCausesFailedValue: Integer;
        NoOfStudentsDecimal: Text;
        ACAStudentUnits: Record UnknownRecord61549;
        CountedRecs: Integer;
        UnitCodes: array [30] of Text[50];
        UnitDescs: array [30] of Text[150];
        UnitCodeLabel: Text;
        UnitDescriptionLabel: Text;
        NoOfStudents: Integer;
        StudUnits: Record UnknownRecord61549;
        ExamsDone: Integer;
        FailCount: Integer;
        Cust: Record Customer;
        Semesters: Record UnknownRecord61692;
        Dimensions: Record "Dimension Value";
        Prog: Record UnknownRecord61511;
        FacDesc: Code[100];
        Depts: Record "Dimension Value";
        Stages: Record UnknownRecord61516;
        StudentsL: Text[250];
        N: Integer;
        Grd: Code[20];
        Marks: Decimal;
        Dimensions2: Record "Dimension Value";
        ResultsStatus: Record UnknownRecord78011;
        ResultsStatus3: Record UnknownRecord78011;
        UnitsRec: Record UnknownRecord61517;
        UnitsDesc: Text[100];
        UnitsHeader: Text[50];
        FailsDesc: Text[200];
        Nx: Integer;
        RegNo: Code[20];
        Names: Text[100];
        Ucount: Integer;
        RegNox: Code[20];
        Namesx: Text[100];
        Nxx: Text[30];
        SemYear: Code[20];
        ShowSem: Boolean;
        SemDesc: Code[100];
        CREG2: Record UnknownRecord61532;
        ExamsProcessing: Codeunit "Exams Processing1";
        CompInf: Record "Company Information";
        YearDesc: Text[30];
        MaxYear: Code[20];
        MaxSem: Code[20];
        CummScore: Decimal;
        CurrScore: Decimal;
        mDate: Date;
        IntakeRec: Record UnknownRecord61383;
        IntakeDesc: Text[100];
        SemFilter: Text[100];
        StageFilter: Text[100];
        MinYear: Code[20];
        MinSem: Code[20];
        StatusNarrations: Text[1000];
        NextYear: Code[20];
        facCode: Code[20];
        progName: Code[150];
        ACAResultsStatus: Record UnknownRecord78011;
        Msg1: Text[250];
        Msg2: Text[250];
        Msg3: Text[250];
        Msg4: Text[250];
        Msg5: Text[250];
        Msg6: Text[250];
        YearOfStudyText: Text[30];
        SaltedExamStatus: Code[1024];
        SaltedExamStatusDesc: Text;
        ACASenateReportStatusBuff: Record UnknownRecord77718 temporary;
        CurrNo: Integer;
        YoS: Code[20];
        CReg33: Record UnknownRecord61532;
        CReg: Record UnknownRecord61532;
        yosInt: Integer;
        ACAUnitsSubjects: Record UnknownRecord61517;
        incounts: Integer;

    local procedure GetYearofStudyText(Yos: Integer) YosText: Text[150]
    begin
        Clear(YosText);
        if Yos=1 then YosText:='FIRST';
        if Yos=2 then YosText:='SECOND';
        if Yos=3 then YosText:='THIRD';
        if Yos=4 then YosText:='FORTH';
        if Yos=5 then YosText:='FIFTH';
        if Yos=6 then YosText:='SIXTH';
        if Yos=7 then YosText:='SEVENTH';
    end;
}

