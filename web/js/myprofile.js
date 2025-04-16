function showProfile() {
    const profileInfo = document.querySelector('.profile-info');
    const bookingHistory = document.querySelector('.booking-history');

    // Thêm hiệu ứng fade-out cho booking history
    bookingHistory.classList.add('fade-out');
    setTimeout(() => {
        bookingHistory.classList.remove('active', 'fade-out');
        profileInfo.classList.add('active', 'fade-in');
    }, 500); // Thời gian trễ để hiệu ứng fade-out hoàn thành
}

function showBookingHistory() {
    const profileInfo = document.querySelector('.profile-info');
    const bookingHistory = document.querySelector('.booking-history');

    // Thêm hiệu ứng fade-out cho profile info
    profileInfo.classList.add('fade-out');
    setTimeout(() => {
        profileInfo.classList.remove('active', 'fade-out');
        bookingHistory.classList.add('active', 'fade-in');
    }, 500); // Thời gian trễ để hiệu ứng fade-out hoàn thành
}

function toggleEdit() {
    const cancelButton = document.querySelector('.cancel-button');
    cancelButton.style.display = cancelButton.style.display === 'none' ? 'inline-block' : 'none';
}

function toggleBookingEdit() {
    const actionCells = document.querySelectorAll('.action-cell');
    const actionHeader = document.querySelector('.action-header');
    const isVisible = actionCells[0].style.display === 'table-cell';

    actionHeader.style.display = isVisible ? 'none' : 'table-cell';
    actionCells.forEach(cell => {
        cell.style.display = isVisible ? 'none' : 'table-cell';
    });
}