#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 78065 "ACA-Res. Approval Entries List"
{
    ApplicationArea = Basic;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    SourceTable = UnknownTable78063;
    SourceTableView = sorting("Approval Series")
                      order(ascending)
                      where(Status=filter(open));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Editable = false;
                field(Programme;Programme)
                {
                    ApplicationArea = Basic;
                }
                field("Unit Code";"Unit Code")
                {
                    ApplicationArea = Basic;
                }
                field(Lecturer;Lecturer)
                {
                    ApplicationArea = Basic;
                }
                field(Semester;Semester)
                {
                    ApplicationArea = Basic;
                }
                field("Academic Year";"Academic Year")
                {
                    ApplicationArea = Basic;
                }
                field("Number of Students";"Number of Students")
                {
                    ApplicationArea = Basic;
                }
                field(Stage;Stage)
                {
                    ApplicationArea = Basic;
                }
                field("Approval Series";"Approval Series")
                {
                    ApplicationArea = Basic;
                }
                field("Approver ID";"Approver ID")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
                field("Approved By";"Approved By")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Approved Date";"Approved Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Approved Time";"Approved Time")
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
            action(PerUnitMarksheet)
            {
                ApplicationArea = Basic;
                Caption = 'Marksheet (Per Unit)';
                Image = CalculatePlan;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = false;

                trigger OnAction()
                begin
                    Clear(AcaResultsBufferPermissions);
                    AcaResultsBufferPermissions.Reset;
                    AcaResultsBufferPermissions.SetRange("User ID",UserId);
                    AcaResultsBufferPermissions.SetRange("Department Code",Rec."Department Code");
                    AcaResultsBufferPermissions.SetRange("Permission Code",AcaResultsBufferPermissions."permission code"::"View Reports");
                    if AcaResultsBufferPermissions.Find('-') then begin
                      if AcaResultsBufferPermissions.Grant = false then Error('Access denied!');
                      end else Error('Access denied.');

                    if Confirm('Print per unit marksheet?',true) = false then Error('Cancelled!');

                    Clear(ACAResultsBufferDetails);
                    ACAResultsBufferDetails.Reset;
                    ACAResultsBufferDetails.SetRange("Academic Year",Rec."Academic Year");
                    ACAResultsBufferDetails.SetRange(Semester,Rec.Semester);
                    ACAResultsBufferDetails.SetRange(Programme,Rec.Programme);
                    ACAResultsBufferDetails.SetRange("Unit Code",Rec."Unit Code");
                    if ACAResultsBufferDetails.Find('-') then Report.Run(78081,true,false,ACAResultsBufferDetails);
                end;
            }
            action(PerLectMarksheet)
            {
                ApplicationArea = Basic;
                Caption = 'Marksheet (Per Lect/Unit)';
                Image = AdjustExchangeRates;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = false;

                trigger OnAction()
                begin
                    Clear(AcaResultsBufferPermissions);
                    AcaResultsBufferPermissions.Reset;
                    AcaResultsBufferPermissions.SetRange("User ID",UserId);
                    AcaResultsBufferPermissions.SetRange("Department Code",Rec."Department Code");
                    AcaResultsBufferPermissions.SetRange("Permission Code",AcaResultsBufferPermissions."permission code"::"View Reports");
                    if AcaResultsBufferPermissions.Find('-') then begin
                      if AcaResultsBufferPermissions.Grant = false then Error('Access denied!');
                      end else Error('Access denied.');
                    if Confirm('Print per Lecturer marksheet?',true) = false then Error('Cancelled!');


                    Clear(ACAResultsBufferDetails);
                    ACAResultsBufferDetails.Reset;
                    ACAResultsBufferDetails.SetRange("Academic Year",Rec."Academic Year");
                    ACAResultsBufferDetails.SetRange(Semester,Rec.Semester);
                    ACAResultsBufferDetails.SetRange(Programme,Rec.Programme);
                    ACAResultsBufferDetails.SetRange("Unit Code",Rec."Unit Code");
                    ACAResultsBufferDetails.SetRange(Lecturer,Rec.Lecturer);
                    if ACAResultsBufferDetails.Find('-') then Report.Run(78080,true,false,ACAResultsBufferDetails);
                end;
            }
            action("Select All")
            {
                ApplicationArea = Basic;
                Image = SelectEntries;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = false;

                trigger OnAction()
                begin
                    Clear(AcaResultsBufferPermissions);
                    AcaResultsBufferPermissions.Reset;
                    AcaResultsBufferPermissions.SetRange("User ID",UserId);
                    AcaResultsBufferPermissions.SetRange("Department Code",Rec."Department Code");
                    AcaResultsBufferPermissions.SetRange("Permission Code",AcaResultsBufferPermissions."permission code"::"Select All");
                    if AcaResultsBufferPermissions.Find('-') then begin
                      if AcaResultsBufferPermissions.Grant = false then Error('Access denied!');
                      end else Error('Access denied.');

                    if Confirm('Select All?',true) = false then Error('Cancelled!');
                    Clear(ACAResultsBufferDetails);
                    ACAResultsBufferDetails.Reset;
                    ACAResultsBufferDetails.SetRange("Academic Year",Rec."Academic Year");
                    ACAResultsBufferDetails.SetRange(Semester,Rec.Semester);
                    ACAResultsBufferDetails.SetRange(Programme,Rec.Programme);
                    ACAResultsBufferDetails.SetRange("Unit Code",Rec."Unit Code");
                    ACAResultsBufferDetails.SetRange(Lecturer,Rec.Lecturer);
                    ACAResultsBufferDetails.SetRange(Select,false);
                    if ACAResultsBufferDetails.Find('-') then begin
                      repeat
                        begin
                          ACAResultsBufferDetails.Select := true;
                          ACAResultsBufferDetails.Modify;
                        end;
                        until ACAResultsBufferDetails.Next = 0;
                      end;
                end;
            }
            action("Unselect All")
            {
                ApplicationArea = Basic;
                Image = UnlimitedCredit;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = false;

                trigger OnAction()
                begin

                    Clear(AcaResultsBufferPermissions);
                    AcaResultsBufferPermissions.Reset;
                    AcaResultsBufferPermissions.SetRange("User ID",UserId);
                    AcaResultsBufferPermissions.SetRange("Department Code",Rec."Department Code");
                    AcaResultsBufferPermissions.SetRange("Permission Code",AcaResultsBufferPermissions."permission code"::"Un-select All");
                    if AcaResultsBufferPermissions.Find('-') then begin
                      if AcaResultsBufferPermissions.Grant = false then Error('Access denied!');
                      end else Error('Access denied.');
                    if Confirm('Unselect All?',true) = false then Error('Cancelled!');

                    Clear(ACAResultsBufferDetails);
                    ACAResultsBufferDetails.Reset;
                    ACAResultsBufferDetails.SetRange("Academic Year",Rec."Academic Year");
                    ACAResultsBufferDetails.SetRange(Semester,Rec.Semester);
                    ACAResultsBufferDetails.SetRange(Programme,Rec.Programme);
                    ACAResultsBufferDetails.SetRange("Unit Code",Rec."Unit Code");
                    ACAResultsBufferDetails.SetRange(Lecturer,Rec.Lecturer);
                    ACAResultsBufferDetails.SetRange(Select,true);
                    if ACAResultsBufferDetails.Find('-') then begin
                      repeat
                        begin
                          ACAResultsBufferDetails.Select := false;
                          ACAResultsBufferDetails.Modify;
                        end;
                        until ACAResultsBufferDetails.Next = 0;
                      end;
                end;
            }
            action("Select All (Without Balance)")
            {
                ApplicationArea = Basic;
                Image = SelectItemSubstitution;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = false;

                trigger OnAction()
                begin
                    Clear(AcaResultsBufferPermissions);
                    AcaResultsBufferPermissions.Reset;
                    AcaResultsBufferPermissions.SetRange("User ID",UserId);
                    AcaResultsBufferPermissions.SetRange("Department Code",Rec."Department Code");
                    AcaResultsBufferPermissions.SetRange("Permission Code",AcaResultsBufferPermissions."permission code"::"Select All");
                    if AcaResultsBufferPermissions.Find('-') then begin
                      if AcaResultsBufferPermissions.Grant = false then Error('Access denied!');
                      end else Error('Access denied.');
                    if Confirm('Select All (Without Balance)?',true) = false then Error('Cancelled!');

                    Clear(ACAResultsBufferDetails);
                    ACAResultsBufferDetails.Reset;
                    ACAResultsBufferDetails.SetRange("Academic Year",Rec."Academic Year");
                    ACAResultsBufferDetails.SetRange(Semester,Rec.Semester);
                    ACAResultsBufferDetails.SetRange(Programme,Rec.Programme);
                    ACAResultsBufferDetails.SetRange("Unit Code",Rec."Unit Code");
                    ACAResultsBufferDetails.SetRange(Lecturer,Rec.Lecturer);
                    ACAResultsBufferDetails.SetRange(Select,false);
                    ACAResultsBufferDetails.SetFilter("Fee Balance",'=%1|<%2',0,0);
                    if ACAResultsBufferDetails.Find('-') then begin
                      repeat
                        begin
                          ACAResultsBufferDetails.Select := true;
                          ACAResultsBufferDetails.Modify;
                        end;
                        until ACAResultsBufferDetails.Next = 0;
                      end;
                end;
            }
            action("Unselect All with Balance")
            {
                ApplicationArea = Basic;
                Image = ConsumptionJournal;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = false;

                trigger OnAction()
                begin
                    Clear(AcaResultsBufferPermissions);
                    AcaResultsBufferPermissions.Reset;
                    AcaResultsBufferPermissions.SetRange("User ID",UserId);
                    AcaResultsBufferPermissions.SetRange("Department Code",Rec."Department Code");
                    AcaResultsBufferPermissions.SetRange("Permission Code",AcaResultsBufferPermissions."permission code"::"Un-select All");
                    if AcaResultsBufferPermissions.Find('-') then begin
                      if AcaResultsBufferPermissions.Grant = false then Error('Access denied!');
                      end else Error('Access denied.');
                    if Confirm('Unselect All with Balance?',true) = false then Error('Cancelled!');

                    Clear(ACAResultsBufferDetails);
                    ACAResultsBufferDetails.Reset;
                    ACAResultsBufferDetails.SetRange("Academic Year",Rec."Academic Year");
                    ACAResultsBufferDetails.SetRange(Semester,Rec.Semester);
                    ACAResultsBufferDetails.SetRange(Programme,Rec.Programme);
                    ACAResultsBufferDetails.SetRange("Unit Code",Rec."Unit Code");
                    ACAResultsBufferDetails.SetRange(Lecturer,Rec.Lecturer);
                    ACAResultsBufferDetails.SetRange(Select,true);
                    ACAResultsBufferDetails.SetFilter("Fee Balance",'>%1',0);
                    if ACAResultsBufferDetails.Find('-') then begin
                      repeat
                        begin
                          ACAResultsBufferDetails.Select := false;
                          ACAResultsBufferDetails.Modify;
                        end;
                        until ACAResultsBufferDetails.Next = 0;
                      end;
                end;
            }
            action("Post Selected")
            {
                ApplicationArea = Basic;
                Image = PostDocument;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = false;

                trigger OnAction()
                begin
                    Clear(AcaResultsBufferPermissions);
                    AcaResultsBufferPermissions.Reset;
                    AcaResultsBufferPermissions.SetRange("User ID",UserId);
                    AcaResultsBufferPermissions.SetRange("Department Code",Rec."Department Code");
                    AcaResultsBufferPermissions.SetRange("Permission Code",AcaResultsBufferPermissions."permission code"::"Post Selected");
                    if AcaResultsBufferPermissions.Find('-') then begin
                      if AcaResultsBufferPermissions.Grant = false then Error('Access denied!');
                      end else Error('Access denied.');
                    if Confirm('Post Selected?',true) = false then Error('Cancelled!');
                    Clear(ACAResultsBufferDetails);
                    ACAResultsBufferDetails.Reset;
                    ACAResultsBufferDetails.SetRange("Academic Year",Rec."Academic Year");
                    ACAResultsBufferDetails.SetRange(Semester,Rec.Semester);
                    ACAResultsBufferDetails.SetRange(Programme,Rec.Programme);
                    ACAResultsBufferDetails.SetRange("Unit Code",Rec."Unit Code");
                    ACAResultsBufferDetails.SetRange(Lecturer,Rec.Lecturer);
                    ACAResultsBufferDetails.SetRange(Select,true);
                    ACAResultsBufferDetails.SetFilter(Posted,'=%1',false);
                    if ACAResultsBufferDetails.Find('-') then begin
                      repeat
                        begin
                        Clear(ACACourseRegistration);
                        Clear(ACAStudentUnits);
                        ACAStudentUnits.Reset;
                        ACAStudentUnits.SetRange(Programme,ACAResultsBufferDetails.Programme);
                        ACAStudentUnits.SetRange(Unit,ACAResultsBufferDetails."Unit Code");
                        ACAStudentUnits.SetRange("Student No.",ACAResultsBufferDetails."Student No.");
                        ACAStudentUnits.SetRange("Reg. Reversed",false);
                        if ACAStudentUnits.Find('-') then begin
                        ACACourseRegistration.Reset;
                        ACACourseRegistration.SetRange("Student No.",ACAResultsBufferDetails."Student No.");
                        ACACourseRegistration.SetRange(Semester,Rec.Semester);
                        ACACourseRegistration.SetRange(Reversed,false);
                        if ACACourseRegistration.Find('-') then begin
                    Clear(ACAResultsBufferMarks);
                    ACAResultsBufferMarks.Reset;
                    ACAResultsBufferMarks.SetRange("Academic Year",ACAResultsBufferDetails."Academic Year");
                    ACAResultsBufferMarks.SetRange(Semester,ACAResultsBufferDetails.Semester);
                    ACAResultsBufferMarks.SetRange(Programme,ACAResultsBufferDetails.Programme);
                    ACAResultsBufferMarks.SetRange("Unit Code",ACAResultsBufferDetails."Unit Code");
                    ACAResultsBufferMarks.SetRange("Student No.",ACAResultsBufferDetails."Student No.");
                    if ACAResultsBufferMarks.Find('-') then begin
                      repeat
                         begin
                            ACAExamResults2.Init;
                            ACAExamResults2."Student No." := ACAResultsBufferMarks."Student No.";
                            ACAExamResults2.Programme := ACAResultsBufferMarks.Programme;
                            ACAExamResults2.Stage := ACAStudentUnits.Stage;
                            ACAExamResults2.Unit := ACAResultsBufferMarks."Unit Code";
                            ACAExamResults2.Semester := ACAResultsBufferMarks.Semester;
                            ACAExamResults2.ExamType := ACAResultsBufferMarks."Exam Type";
                            ACAExamResults2."Reg. Transaction ID" := ACACourseRegistration."Reg. Transacton ID";
                         if ACAExamResults2.Insert then;

                          Clear(ACAExamResults);
                          ACAExamResults.Reset;
                          ACAExamResults.SetRange(Semester,ACAResultsBufferMarks.Semester);
                          ACAExamResults.SetRange(Unit,ACAResultsBufferMarks."Unit Code");
                          ACAExamResults.SetRange(Programme,ACAResultsBufferMarks.Programme);
                          ACAExamResults.SetRange("Student No.",ACAResultsBufferMarks."Student No.");
                          ACAExamResults.SetRange(ExamType,ACAResultsBufferMarks."Exam Type");
                          if ACAExamResults.Find('-') then begin
                          repeat
                          begin
                          // Update Score
                          ACAExamResults.Score := ACAResultsBufferMarks."Score Decimal";
                          ACAExamResults.Modify;
                          ACAResultsBufferDetails.Posted := true;
                          ACAResultsBufferDetails.Modify;
                          end;
                          until ACAExamResults.Next = 0;
                          end;
                         end;
                        until ACAResultsBufferMarks.Next = 0;
                      end;
                      end // end course registration
                      else begin
                      // - - Course Registration is Missing
                      end;
                      end// End Units Registration Check
                      else begin
                      // - - - - Unts Registration is Missing
                      end;
                        end;
                        until ACAResultsBufferDetails.Next = 0;
                      end;
                end;
            }
            action("Un-Post Selected")
            {
                ApplicationArea = Basic;
                Image = UnApply;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = false;

                trigger OnAction()
                begin

                    Clear(AcaResultsBufferPermissions);
                    AcaResultsBufferPermissions.Reset;
                    AcaResultsBufferPermissions.SetRange("User ID",UserId);
                    AcaResultsBufferPermissions.SetRange("Department Code",Rec."Department Code");
                    AcaResultsBufferPermissions.SetRange("Permission Code",AcaResultsBufferPermissions."permission code"::"Un-post Selected");
                    if AcaResultsBufferPermissions.Find('-') then begin
                      if AcaResultsBufferPermissions.Grant = false then Error('Access denied!');
                      end else Error('Access denied.');

                    if Confirm('Un-post Selected?',true) = false then Error('Cancelled!');
                    Clear(ACAResultsBufferDetails);
                    ACAResultsBufferDetails.Reset;
                    ACAResultsBufferDetails.SetRange("Academic Year",Rec."Academic Year");
                    ACAResultsBufferDetails.SetRange(Semester,Rec.Semester);
                    ACAResultsBufferDetails.SetRange(Programme,Rec.Programme);
                    ACAResultsBufferDetails.SetRange("Unit Code",Rec."Unit Code");
                    ACAResultsBufferDetails.SetRange(Lecturer,Rec.Lecturer);
                    ACAResultsBufferDetails.SetRange(Select,true);
                    ACAResultsBufferDetails.SetFilter(Posted,'=%1',true);
                    if ACAResultsBufferDetails.Find('-') then begin
                      repeat
                        begin
                        Clear(ACACourseRegistration);
                        Clear(ACAStudentUnits);
                        ACAStudentUnits.Reset;
                        ACAStudentUnits.SetRange(Programme,ACAResultsBufferDetails.Programme);
                        ACAStudentUnits.SetRange(Unit,ACAResultsBufferDetails."Unit Code");
                        ACAStudentUnits.SetRange("Student No.",ACAResultsBufferDetails."Student No.");
                        ACAStudentUnits.SetRange("Reg. Reversed",false);
                        if ACAStudentUnits.Find('-') then begin
                        ACACourseRegistration.Reset;
                        ACACourseRegistration.SetRange("Student No.",ACAResultsBufferDetails."Student No.");
                        ACACourseRegistration.SetRange(Semester,Rec.Semester);
                        ACACourseRegistration.SetRange(Reversed,false);
                        if ACACourseRegistration.Find('-') then begin
                    Clear(ACAResultsBufferMarks);
                    ACAResultsBufferMarks.Reset;
                    ACAResultsBufferMarks.SetRange("Academic Year",ACAResultsBufferDetails."Academic Year");
                    ACAResultsBufferMarks.SetRange(Semester,ACAResultsBufferDetails.Semester);
                    ACAResultsBufferMarks.SetRange(Programme,ACAResultsBufferDetails.Programme);
                    ACAResultsBufferMarks.SetRange("Unit Code",ACAResultsBufferDetails."Unit Code");
                    ACAResultsBufferMarks.SetRange("Student No.",ACAResultsBufferDetails."Student No.");
                    if ACAResultsBufferMarks.Find('-') then begin
                      repeat
                         begin
                          Clear(ACAExamResults);
                          ACAExamResults.Reset;
                          ACAExamResults.SetRange(Semester,ACAResultsBufferMarks.Semester);
                          ACAExamResults.SetRange(Unit,ACAResultsBufferMarks."Unit Code");
                          ACAExamResults.SetRange(Programme,ACAResultsBufferMarks.Programme);
                          ACAExamResults.SetRange("Student No.",ACAResultsBufferMarks."Student No.");
                          ACAExamResults.SetRange(ExamType,ACAResultsBufferMarks."Exam Type");
                          if ACAExamResults.Find('-') then begin
                          repeat
                          begin
                          // Delete Score
                          ACAExamResults.Delete;
                          end;
                          until ACAExamResults.Next = 0;
                          end;
                         end;
                        until ACAResultsBufferMarks.Next = 0;
                      end;
                      end // end course registration
                      else begin
                      // - - Course Registration is Missing
                      end;
                      end// End Units Registration Check
                      else begin
                      // - - - - Unts Registration is Missing
                      end;
                        end;
                        until ACAResultsBufferDetails.Next = 0;
                      end;
                end;
            }
            action(EditList)
            {
                ApplicationArea = Basic;
                Caption = 'Edit Entry';
                Image = Edit;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    Clear(ACAResultMatrixFilters);
                    ACAResultMatrixFilters.Reset;
                    ACAResultMatrixFilters.SetRange("User-Id",UserId);
                    if ACAResultMatrixFilters.Find('-') then ACAResultMatrixFilters.DeleteAll;
                    ACAResultMatrixFilters.Init;
                    ACAResultMatrixFilters."Academic Year" := Rec."Academic Year";
                    ACAResultMatrixFilters.Semester := Rec.Semester;
                    ACAResultMatrixFilters.Programme := Rec.Programme;
                    ACAResultMatrixFilters."User-Id" := UserId;
                    ACAResultMatrixFilters.Insert;

                    if Rec."Approval Category" = Rec."approval category"::"Per Unit" then begin
                    Clear(ACAResultsBufferHeader);
                    ACAResultsBufferHeader.Reset;
                    ACAResultsBufferHeader.SetRange("Academic Year",Rec."Academic Year");
                    ACAResultsBufferHeader.SetRange(Semester,Rec.Semester);
                    ACAResultsBufferHeader.SetRange(Programme,Rec.Programme);
                    ACAResultsBufferHeader.SetRange("Unit Code",Rec."Unit Code");
                    if ACAResultsBufferHeader.Find('-') then
                      Page.Run(78053,ACAResultsBufferHeader);
                      end else begin
                    ////////////////////// if its a Per Program Approval
                    Clear(ACAResultsApprovalEntries);
                    ACAResultsApprovalEntries.Reset;
                    ACAResultsApprovalEntries.SetRange("Academic Year",Rec."Academic Year");
                    ACAResultsApprovalEntries.SetRange(Semester,Rec.Semester);
                    ACAResultsApprovalEntries.SetRange(Programme,Rec.Programme);
                    ACAResultsApprovalEntries.SetRange("Unit Code",Rec."Unit Code");
                    ACAResultsApprovalEntries.SetRange("Approver ID",Rec."Approver ID");
                    ACAResultsApprovalEntries.SetRange("Approval Category",Rec."Approval Category");
                    ACAResultsApprovalEntries.SetRange("Approval Series",Rec."Approval Series");
                    if ACAResultsApprovalEntries.Find('-') then
                      Page.Run(78064,ACAResultsApprovalEntries);
                      end;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetFilter("Approver ID",UserId);
    end;

    trigger OnOpenPage()
    begin
        SetFilter("Approver ID",UserId);
    end;

    var
        ACAResultsBufferDetails: Record UnknownRecord78054;
        ACAExamResults: Record UnknownRecord61548;
        ACAResultsBufferMarks: Record UnknownRecord78055;
        ACACourseRegistration: Record UnknownRecord61532;
        ACAExamResults2: Record UnknownRecord61548;
        ACAStudentUnits: Record UnknownRecord61549;
        AcaResultsBufferPermissions: Record UnknownRecord78057;
        ACAResultsBufferDetails2: Record UnknownRecord78054;
        ACAResultsApprovalEntries: Record UnknownRecord78063;
        ACAResultMatrixFilters: Record UnknownRecord78067;
        ACAResultsBufferHeader: Record UnknownRecord78053;
}

