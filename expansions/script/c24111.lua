--『蔷薇地狱』
function c24111.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,24111+EFFECT_COUNT_CODE_DUEL)
	e1:SetCondition(c24111.condition)
	e1:SetTarget(c24111.target)
	e1:SetOperation(c24111.activate)
	c:RegisterEffect(e1)
	if c24111.counter==nil then
		c24111.counter=true
		c24111.lplist = {
			[0] = Duel.GetLP(tp),
			[1] = Duel.GetLP(tp),
		}
		c24111.effectList = {
			[0] = {},
			[1] = {},
		}
	end
end
function c24111.filter(c)
	return not (c:IsFaceup() and c:IsSetCard(0x514a))
end
function c24111.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c24111.filter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0
end
function c24111.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c24111.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetCondition(c24111.con)
	e1:SetValue(c24111.damval)
	e1:SetLabel(tp)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCountLimit(1)
	e2:SetCondition(c24111.con)
	e2:SetOperation(c24111.count)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ADJUST)
	e3:SetOperation(c24111.lpop)
	Duel.RegisterEffect(e3,tp)
	c24111.effectList[tp] = {e1,e2,e3}
end
function c24111.con(e,tp,eg,ep,ev,re,r,rp)
	return c24111.lplist[e:GetLabel()]>Duel.GetLP(e:GetLabel())
end
function c24111.damval(e,re,val,r,rp,rc)
	if bit.band(r,REASON_BATTLE)~=0 then return val end
	if val>=1000 then return 0 else return val end
end
function c24111.count(e,tp,eg,ep,ev,re,r,rp)
	local lp=Duel.GetLP(tp)
	if Duel.GetLP(tp)>=c24111.lplist[tp] then return end 
	local rev=c24111.lplist[tp]-lp
	if rev>2000 then
		Duel.Recover(tp,2000,REASON_EFFECT)
	elseif rev>0 then
		Duel.Recover(tp,rev,REASON_EFFECT)
	end
end
function c24111.lpop(e,tp,eg,ep,ev,re,r,rp)
	local lp=Duel.GetLP(tp)
	if lp>=c24111.lplist[tp] then
		for _,v in pairs(c24111.effectList[tp]) do
			v:Reset()
		end
		c24111.effectList[tp] = {}
	end
end
