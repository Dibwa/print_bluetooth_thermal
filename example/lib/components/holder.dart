  /* Expanded(
          flex: 7,
          child: Column(
            children: [
              Visibility(
                visible: listVisibity,
                child: Expanded(
                  child: ListView.builder(
                      itemCount: todolist.length,
                      itemBuilder: (context, index) {
                        return TransactionTile(
                          view: () {
                            setState(() {
                              listVisibity = false;
                              mapVisibility = true;
                            });
                          },
                          shopName: todolist[index][0],
                          ownerNames: todolist[index][1],
                          contact: todolist[index][2],
                        );
                      }),
                ),
              ),
            
            ],
          ),
        )*/