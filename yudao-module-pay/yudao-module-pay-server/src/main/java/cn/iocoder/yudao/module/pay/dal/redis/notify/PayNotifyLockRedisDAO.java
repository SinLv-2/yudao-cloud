package cn.iocoder.yudao.module.pay.dal.redis.notify;

import org.redisson.api.RLock;
import org.redisson.api.RedissonClient;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.concurrent.TimeUnit;

import static cn.iocoder.yudao.module.pay.dal.redis.RedisKeyConstants.PAY_NOTIFY_LOCK;

/**
 * 支付通知的锁 Redis DAO
 *
 * @author 芋道源码
 */
@Repository
public class PayNotifyLockRedisDAO {

    @Resource
    private RedissonClient redissonClient;

    /**
     * 加锁，执行 runnable 逻辑，最后释放锁
     *
     * @param id            锁的 ID
     * @param timeoutMillis 拿到锁后，锁的最长持有时间，单位：毫秒
     * @param runnable      执行逻辑
     */
    public void lock(Long id, Long timeoutMillis, Runnable runnable) {
        String lockKey = formatKey(id);
        RLock lock = redissonClient.getLock(lockKey);
        try {
            lock.lock(timeoutMillis, TimeUnit.MILLISECONDS);
            // 执行逻辑
            runnable.run();
        } finally {
            lock.unlock();
        }
    }
    /**
     * 尝试加锁，成功则执行 runnable 逻辑，失败则抛出异常(推荐)
     *
     * @param id            锁的 ID
     * @param waitTime      获取锁的最大等待时间，单位：毫秒
     * @param timeoutMillis 锁的超时时间，单位：毫秒
     * @param runnable      执行逻辑
     */
    public void tryLock(Long id, Long waitTime, Long timeoutMillis, Runnable runnable) {
        String lockKey = formatKey(id);
        RLock lock = redissonClient.getLock(lockKey);
        boolean acquired = false;
        try {
            acquired = lock.tryLock(waitTime, timeoutMillis, TimeUnit.MILLISECONDS);
            if (acquired) {
                // 执行逻辑
                runnable.run();
            } else {
                // 未能获取锁，可以选择抛出异常或记录日志
                throw new RuntimeException("Could not acquire lock for key: " + lockKey);
            }
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new RuntimeException("Thread was interrupted while trying to acquire lock for key: " + lockKey, e);
        } finally {
            if (acquired && lock.isHeldByCurrentThread()) {
                lock.unlock();
            }
        }
    }

    private static String formatKey(Long id) {
        return String.format(PAY_NOTIFY_LOCK, id);
    }

}
