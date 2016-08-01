--
Ets={}
--ETS
local ETStore = {}
function Ets.EffectTempStore(e,num)
	if ETStore[num]==nil then ETStore[num]=e end
end
function Ets.EffectTempCloneConChange(c,num,f)
	if ETStore[num]~=nil then 
		local e0=ETStore[num]:Clone()
		e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_DAMAGE_STEP)
		e0:SetCondition(f)
		e0:SetLabel(num)
		c:RegisterEffect(e0)
	end
end
function Ets.RegCommonEffect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(c:GetOriginalCode(),0))
	e0:SetCategory(CATEGORY_DESTROY)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e0:SetCode(EVENT_BATTLE_DESTROYING)
	e0:SetCondition(Ets.con0)
	e0:SetTarget(Ets.tg)
	e0:SetOperation(Ets.op)
	c:RegisterEffect(e0)
	local e1=e0:Clone()
	e1:SetCondition(Ets.con1)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	c:RegisterEffect(e1)
	return e0,e1
end
function Ets.con0(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(999100)>0 then return false end
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and bc:IsType(TYPE_MONSTER)
end
function Ets.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(999100)<1 then return false end
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and bc:IsType(TYPE_MONSTER)
end
function Ets.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,c,1,0,0)
end
function Ets.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end