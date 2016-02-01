
#import "NewGSMViewController.h"
#import "GSMDetailsViewController.h"
#import "GSM.h"

@interface NewGSMViewController () <UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *model;
@property NSMutableArray* gsms;
@end

@implementation NewGSMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    [self.tableview setAllowsSelection:YES];
    self.gsms = [NSMutableArray new];
    self.name.placeholder = @"Name";
    self.model.placeholder = @"Manufacturer";

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)createNewTapped:(id)sender {
    GSM* newGSM = [GSM gsmWithModel:self.name.text andManufacturer:self.model.text];
    [self.gsms addObject:newGSM];
    [self.tableview reloadData];
   // GSMTableViewController *rvController = [self.storyboard instantiateViewControllerWithIdentifier:@"1"];
   // NSLog(@"%d", [rvController.gsms count]);


    //[self.navigationController pushViewController:rvController animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.gsms count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    GSM* gsm = [self.gsms objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"Model: %@   Manufacturer: %@", gsm.model, gsm.manufacturer];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GSM* gsm = [self.gsms objectAtIndex:indexPath.row];
    
    GSMDetailsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"DestinationController"];
    controller.gsm = gsm;
    //[self presentViewController:controller animated:YES completion:nil];
    [self.navigationController pushViewController:controller animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
