/*
	wcfProjectItem.h
	The interface definition of properties and methods for the wcfProjectItem object.
	Generated by SudzC.com
 */

#import "Soap.h"


@interface wcfProjectItem : SoapObject
{
    int _ActiveUnits;
    NSString* _AddPMNotes;
    NSString* _AddPhoto;
    BOOL _ArchiveYN;
    NSString* _Asking;
    BOOL _Askingyn;
    BOOL _BasePlanyn;
    NSString* _Baths;
    NSString* _Bedrooms;
    NSString* _Block;
    BOOL _Brochure;
    NSString* _BrochureLength;
    NSString* _City;
    int _ClosedUnits;
    NSString* _Elovecia;
    BOOL _ForPermitting;
    NSString* _Garage;
    BOOL _HasVendorYN;
    NSString* _IDFloorplan;
    NSString* _IdContract;
    NSString* _IdQaInspection;
    NSString* _Lot;
    NSString* _Name;
    NSString* _PM1;
    NSString* _PM1Email;
    NSString* _PM2;
    NSString* _PM2Email;
    NSString* _PM3;
    NSString* _PM3Email;
    NSString* _PM4;
    NSString* _PM4Email;
    NSString* _Permit;
    NSString* _PlanName;
    BOOL _Repeated;
    BOOL _Reverseyn;
    int _Revision;
    NSString* _Sales1;
    NSString* _Sales1Email;
    NSString* _Sales2;
    NSString* _Sales2Email;
    NSString* _Section;
    BOOL _SiteMapyn;
    NSString* _Sold;
    int _SoldUnits;
    int _SpecsUnits;
    NSString* _Stage;
    NSString* _Status;
    int _TotalUnits;
    BOOL _UnderRevision;
    NSString* _contractCnt;
    BOOL _contractyn;
    BOOL _coyn;
    NSString* _mastercia;
    BOOL _poyn;
    NSString* _requestvpo;
    NSString* _sqft;
    
    BOOL _newinterior;
    BOOL _newexterior;
    
}

@property int ActiveUnits;
@property (retain, nonatomic) NSString* AddPMNotes;
@property (retain, nonatomic) NSString* AddPhoto;
@property BOOL ArchiveYN;
@property (retain, nonatomic) NSString* Asking;
@property BOOL Askingyn;
@property BOOL BasePlanyn;
@property (retain, nonatomic) NSString* Baths;
@property (retain, nonatomic) NSString* Bedrooms;
@property (retain, nonatomic) NSString* Block;
@property BOOL Brochure;
@property (retain, nonatomic) NSString* BrochureLength;
@property (retain, nonatomic) NSString* City;
@property int ClosedUnits;
@property (retain, nonatomic) NSString* Elovecia;
@property BOOL ForPermitting;
@property (retain, nonatomic) NSString* Garage;
@property BOOL HasVendorYN;
@property (retain, nonatomic) NSString* IDFloorplan;
@property (retain, nonatomic) NSString* IdContract;
@property (retain, nonatomic) NSString* IdQaInspection;
@property (retain, nonatomic) NSString* Lot;
@property (retain, nonatomic) NSString* Name;
@property (retain, nonatomic) NSString* PM1;
@property (retain, nonatomic) NSString* PM1Email;
@property (retain, nonatomic) NSString* PM2;
@property (retain, nonatomic) NSString* PM2Email;
@property (retain, nonatomic) NSString* PM3;
@property (retain, nonatomic) NSString* PM3Email;
@property (retain, nonatomic) NSString* PM4;
@property (retain, nonatomic) NSString* PM4Email;
@property (retain, nonatomic) NSString* Permit;
@property (retain, nonatomic) NSString* PlanName;
@property BOOL Repeated;
@property BOOL Reverseyn;
@property int Revision;
@property (retain, nonatomic) NSString* Sales1;
@property (retain, nonatomic) NSString* Sales1Email;
@property (retain, nonatomic) NSString* Sales2;
@property (retain, nonatomic) NSString* Sales2Email;
@property (retain, nonatomic) NSString* Section;
@property BOOL SiteMapyn;
@property (retain, nonatomic) NSString* Sold;
@property int SoldUnits;
@property int SpecsUnits;
@property (retain, nonatomic) NSString* Stage;
@property (retain, nonatomic) NSString* Status;
@property int TotalUnits;
@property BOOL UnderRevision;
@property (retain, nonatomic) NSString* contractCnt;
@property BOOL contractyn;
@property BOOL coyn;
@property (retain, nonatomic) NSString* mastercia;
@property BOOL poyn;
@property (retain, nonatomic) NSString* requestvpo;
@property (retain, nonatomic) NSString* sqft;
@property BOOL newinterior;
@property BOOL newexterior;

+ (wcfProjectItem*) newWithNode: (CXMLNode*) node;
- (id) initWithNode: (CXMLNode*) node;
- (NSMutableString*) serialize;
- (NSMutableString*) serialize: (NSString*) nodeName;
- (NSMutableString*) serializeAttributes;
- (NSMutableString*) serializeElements;

@end
