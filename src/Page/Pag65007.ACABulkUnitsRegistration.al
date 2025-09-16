#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 65007 "ACA-Bulk Units Registration"
{
    PageType = Card;
    SourceTable = "ACA-Bulk Units Registration";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Semester Code";"Semester Code")
                {
                    ApplicationArea = Basic;
                }
                field("Academic Year";"Academic Year")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Program Code";"Program Code")
                {
                    ApplicationArea = Basic;
                }
                field("Unit Code";"Unit Code")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Dets)
            {
                Caption = 'Details';
                part(DetailsPage;"ACA-Bulk Unit Reg. Det")
                {
                    Caption = 'Details Page';
                    SubPageLink = "Semester Code"=field("Semester Code"),
                                  "Program Code"=field("Program Code"),
                                  "Unit Code"=field("Unit Code");
                }
            }
            group(History)
            {
                Caption = 'History';
                part(Hist;"ACA-Bulk Unit Reg. Hist")
                {
                    Caption = 'Upload History';
                    SubPageLink = "Semester Code"=field("Semester Code"),
                                  "Program Code"=field("Program Code"),
                                  "Unit Code"=field("Unit Code");
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(Imp)
            {
                ApplicationArea = Basic;
                Caption = 'Import Units Registration';
                Image = AddContacts;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Clear(UserSetup);
                    UserSetup.Reset;
                    UserSetup.SetRange("User ID",UserId);
                    if UserSetup.Find('-') then
                      UserSetup.TestField("Bulk upload of Units")
                    else Error('Access denied!');

                    if Confirm('Import Units Registration?',true)=false then Error('Cancelled by user!');
                    if Confirm('Arrange your CSV file in this format:\Semester\Programme\Unit Code\Student No.',true) = true  then
                      Xmlport.Run(50206,false,true);
                end;
            }
            action(Posts)
            {
                ApplicationArea = Basic;
                Caption = 'Post Units';
                Image = BreakpointsList;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if Confirm('Post?',true)=false then Error('Cancelled');
                    Clear(UserSetup);
                    UserSetup.Reset;
                    UserSetup.SetRange("User ID",UserId);
                    if UserSetup.Find('-') then
                      UserSetup.TestField("Bulk upload of Units")
                    else Error('Access denied!');
                    Clear(ACABulkUnitsRegDet);
                    ACABulkUnitsRegDet.Reset;
                    ACABulkUnitsRegDet.SetRange("Semester Code",Rec."Semester Code");
                    ACABulkUnitsRegDet.SetRange("Program Code",Rec."Program Code");
                    ACABulkUnitsRegDet.SetRange("Unit Code",Rec."Unit Code");
                    ACABulkUnitsRegDet.SetRange(Registered,false);
                    if ACABulkUnitsRegDet.Find('-') then begin
                      repeat
                          begin
                            Clear(ACACourseRegistration);
                            ACACourseRegistration.Reset;
                            ACACourseRegistration.SetRange(Reversed,false);
                            ACACourseRegistration.SetRange("Student No.",ACABulkUnitsRegDet."Student No.");
                            ACACourseRegistration.SetRange(Programme,Rec."Program Code");
                            ACACourseRegistration.SetRange(Semester,Rec."Semester Code");
                            if ACACourseRegistration.Find('-') then begin
                              Clear(ACAUnitsSubjects);
                              ACAUnitsSubjects.Reset;
                              ACAUnitsSubjects.SetRange(Code,ACABulkUnitsRegDet."Unit Code");
                              ACAUnitsSubjects.SetRange("Programme Code",Rec."Program Code");
                              if ACAUnitsSubjects.Find('-') then begin
                                  ACAStudentUnits.Init;
                                  ACAStudentUnits.Stage := ACACourseRegistration.Stage;
                                  ACAStudentUnits.Unit := ACABulkUnitsRegDet."Unit Code";
                                  ACAStudentUnits.Programme := Rec."Program Code";
                                  ACAStudentUnits.Semester := ACACourseRegistration.Semester;
                                  ACAStudentUnits."Reg. Transacton ID" := ACACourseRegistration."Reg. Transacton ID";
                                  ACAStudentUnits."Student No." := ACACourseRegistration."Student No.";
                                  ACAStudentUnits."Academic Year" := ACACourseRegistration."Academic Year";
                                  ACAStudentUnits."Register for" := ACAStudentUnits."register for"::Stage;
                                  ACAStudentUnits."Unit Type" := ACAUnitsSubjects."Unit Type";
                                  ACAStudentUnits."Created by":=UserSetup."User ID";
                                  ACAStudentUnits.Taken := true;
                                  ACAStudentUnits."Unit Stage" := ACAUnitsSubjects."Stage Code";
                                if ACAStudentUnits.Insert then begin
                                end;
                                end;
                              end;
                          end;
                        until ACABulkUnitsRegDet.Next=0;
                        Message('Successful')
                      end;

                end;
            }
        }
    }

    var
        ACAStudentUnits: Record UnknownRecord61549;
        ACABulkUnitsRegDet: Record "ACA-Bulk Units Reg. Det";
        ACAUnitsSubjects: Record UnknownRecord61517;
        ACACourseRegistration: Record UnknownRecord61532;
        UserSetup: Record "User Setup";
}

