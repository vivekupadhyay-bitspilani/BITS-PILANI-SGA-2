#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>

// Employee structure definition
typedef struct {
    int id;
    char name[50];
    double salary;
} Employee;

// Helper function to display employee details
void display_employee(const char* label, Employee emp) {
    printf("%s -> ID: %d, Name: %s, Salary: $%.2f\n", label, emp.id, emp.name, emp.salary);
}

int main() {
    const char *filename = "employees.dat";
    
    // 1. Create / Open file with read & write permissions using open()
    int fd = open(filename, O_CREAT | O_RDWR | O_TRUNC, 0644);
    if (fd < 0) {
        perror("Error creating file with open()");
        exit(1);
    }
    printf("=== Secure Employee File Processing Utility ===\n\n");
    printf("[1] File '%s' created successfully using open().\n\n", filename);

    // 2. Write initial employee records using write()
    Employee e1 = {101, "Alice Smith", 75000.00};
    Employee e2 = {102, "Bob Jones", 62000.00};
    Employee e3 = {103, "Charlie Brown", 88000.00};

    write(fd, &e1, sizeof(Employee));
    write(fd, &e2, sizeof(Employee));
    write(fd, &e3, sizeof(Employee));
    printf("[2] Written 3 employee records using write().\n\n");

    // 3. Retrieve Record 2 efficiently before update using lseek() and read()
    Employee temp;
    off_t offset_rec2 = (2 - 1) * sizeof(Employee); // 0-indexed byte offset for Record 2
    
    lseek(fd, offset_rec2, SEEK_SET);
    read(fd, &temp, sizeof(Employee));
    display_employee("[3] Retrieved Record 2 (Before Update)", temp);

    // 4. Update Record 2 in-place without rewriting entire file using lseek() and write()
    Employee e2_updated = {102, "Bob Jones", 70000.00}; // Updated salary
    lseek(fd, offset_rec2, SEEK_SET); // Move file offset back to Record 2 start
    write(fd, &e2_updated, sizeof(Employee));
    printf("\n[4] Updated Record 2 in-place using lseek() and write().\n\n");

    // 5. Retrieve all records sequentially to verify in-place modification
    printf("[5] Retrieving all records sequentially from file after in-place update:\n");
    lseek(fd, 0, SEEK_SET); // Reset pointer to start of file
    
    Employee read_emp;
    int rec_num = 1;
    while (read(fd, &read_emp, sizeof(Employee)) > 0) {
        char label[30];
        sprintf(label, "    Record %d", rec_num++);
        display_employee(label, read_emp);
    }

    // 6. Close file descriptor using close()
    close(fd);
    printf("\n[6] File descriptor closed cleanly using close().\n");

    return 0;
}
