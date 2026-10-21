package _ppl.production.impl;

import _ppl.production.entity.Department;
import _ppl.production.repository.DepartmentRepository;
import _ppl.production.service.DepartmentService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Transactional
public class DepartmentServiceImpl implements DepartmentService {

    private final DepartmentRepository departmentRepository;

    @Override
    @Transactional(readOnly = true)
    public List<Department> findAll() {
        return departmentRepository.findAll();
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<Department> findById(Long id) {
        return departmentRepository.findById(id);
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<Department> findByCode(String code) {
        return departmentRepository.findByCode(code);
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<Department> findByName(String name) {
        return departmentRepository.findByName(name);
    }

    @Override
    public Department save(Department department) {
        validate(department);

        if (departmentRepository.existsByName(department.getName())) {
            throw new RuntimeException("Tên khoa / bộ môn đã tồn tại");
        }

        if (department.getCode() != null
                && !department.getCode().isBlank()
                && departmentRepository.existsByCode(department.getCode())) {
            throw new RuntimeException("Mã khoa / bộ môn đã tồn tại");
        }

        return departmentRepository.save(department);
    }

    @Override
    public Department update(Long id, Department department) {

        Department existing = departmentRepository.findById(id)
                .orElseThrow(() ->
                        new RuntimeException("Không tìm thấy khoa / bộ môn"));

        validate(department);

        Optional<Department> byName =
                departmentRepository.findByName(department.getName());

        if (byName.isPresent()
                && !byName.get().getId().equals(id)) {
            throw new RuntimeException("Tên khoa / bộ môn đã tồn tại");
        }

        if (department.getCode() != null
                && !department.getCode().isBlank()) {

            Optional<Department> byCode =
                    departmentRepository.findByCode(department.getCode());

            if (byCode.isPresent()
                    && !byCode.get().getId().equals(id)) {
                throw new RuntimeException("Mã khoa / bộ môn đã tồn tại");
            }
        }

        existing.setName(department.getName());
        existing.setCode(department.getCode());
        existing.setDescription(department.getDescription());

        return departmentRepository.save(existing);
    }

    @Override
    public void deleteById(Long id) {

        if (!departmentRepository.existsById(id)) {
            throw new RuntimeException(
                    "Không tìm thấy khoa / bộ môn");
        }

        departmentRepository.deleteById(id);
    }

    private void validate(Department department) {

        if (department.getName() == null
                || department.getName().isBlank()) {
            throw new RuntimeException(
                    "Tên khoa / bộ môn không được để trống");
        }
    }
}